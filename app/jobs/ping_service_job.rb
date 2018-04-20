class PingServiceJob < ActiveJob::Base
  queue_as :default

  def perform(service)
    nPings = Setting.n_pings
    pings = nPings.times.collect{service.execute_single_ping}.compact
    delaysum = pings.reduce(:+)
    del_ratio = pings.length.fdiv(nPings)
    if delaysum == nil
      service.monitored_service_logs.create!(delivery_ratio: del_ratio)
      update_service_and_notify_if_state_changed_past_stabilization_delay :down, service
    else
      avg_delay = delaysum.fdiv(nPings)
      service.monitored_service_logs.create!(delay: avg_delay, delivery_ratio: del_ratio)
      if avg_delay >= service.warning_delay*0.001
        update_service_and_notify_if_state_changed_past_stabilization_delay :warning, service
      else
        update_service_and_notify_if_state_changed_past_stabilization_delay :up, service
      end
    end
  end
  
  private
  
  def enqueue_notifications status, service
    unless status == :warning and not Setting.should_notify_warning_status 
      status = status.to_s
      NotifyTelegramSubscribersJob.perform_later status, service if Setting.send_telegram_notifications
      ServiceNotifier.notify_service_event(status, service).deliver_later if Setting.send_email_notifications
    end
  end
  
  def update_service_and_notify_if_state_changed_past_stabilization_delay status, service
    if service.status == status.to_s
      service.update!(new_status_time: nil, force_create: true) unless service.new_status_time.nil?
    else
      curr_time = Time.now.in_time_zone
      if service.new_status_time.nil?
        service.update!(new_status_time: (curr_time + Setting.stabilization_delay.seconds), force_create: true)
      elsif curr_time >= service.new_status_time 
        enqueue_notifications(status, service)
        service.update!(status: status, new_status_time: nil, force_create: true)
      end
    end
  end
end
