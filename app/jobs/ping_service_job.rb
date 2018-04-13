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
      if avg_delay >= Setting.warning_delay
        update_service_and_notify_if_state_changed_past_stabilization_delay :warning, service
      else
        update_service_and_notify_if_state_changed_past_stabilization_delay :up, service
      end
    end
  end
  
  private
  
  def enqueue_notifications status, service
    unless status == "warning" and not Setting.should_notify_warning_status 
      NotifyTelegramSubscribersJob.perform_later status, service if Setting.send_telegram_notifications
      ServiceNotifier.notify_service_event(status, service).deliver_later! if Setting.send_email_notifications
    end
  end
  
  def update_service_and_notify_if_state_changed_past_stabilization_delay new_status, service
    status = new_status.is_a?(Symbol) ? new_status : new_status.to_sym
    curr_time = Time.now
    if service.status == status
      service.update!(new_status_time: nil, force_create: true) unless service.new_status_time.blank?
    else
      if service.new_status_time.nil?
        service.update!(new_status_time: (curr_time + Setting.stabilization_delay.seconds), force_create: true)
      elsif curr_time >= service.new_status_time #DateTime differences are given in days, hence the multiplication
        enqueue_notifications(new_status.to_s, service)
        service.update!(status: new_status, new_status_time: nil, force_create: true)
      end
    end
  end
end
