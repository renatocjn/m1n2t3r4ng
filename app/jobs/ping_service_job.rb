class PingServiceJob < ActiveJob::Base
  queue_as :default

  def perform(service)
    nPings = Setting.n_pings
    pings = nPings.times.collect{service.execute_single_ping}.compact
    delaysum = pings.reduce(:+)
    del_ratio = pings.length.fdiv(nPings)
    if delaysum == nil
      service.monitored_service_logs.create!(delivery_ratio: del_ratio)
      if not service.down?
        enqueue_notifications("down", service)
        service.update!(status: :down, force_create: true)
      end
    else
      avg_delay = delaysum.fdiv(nPings)
      service.monitored_service_logs.create!(delay: avg_delay, delivery_ratio: del_ratio)
      if avg_delay >= Setting.warning_delay and not service.warning?
        enqueue_notifications("warning", service)
        service.update!(status: :warning, force_create: true)
      elsif not service.up?
        enqueue_notifications("up", service)
        service.update!(status: :up, force_create: true)
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
end
