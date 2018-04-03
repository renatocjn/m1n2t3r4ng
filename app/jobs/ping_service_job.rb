class PingServiceJob < ActiveJob::Base
  queue_as :default

  def perform(monitored_service)
    nPings = Setting.n_pings
    pings = nPings.times.collect{monitored_service.execute_single_ping}.compact
    delaysum = pings.reduce(:+)
    del_ratio = pings.length.fdiv(nPings)
    if delaysum == nil
      monitored_service.monitored_service_logs.create!(delivery_ratio: del_ratio)
      if Setting.send_email_notifications and monitored_service.up?
        ServiceNotifier.notify_service_event("down", monitored_service).deliver_later!
      end
      if Setting.send_telegram_notifications and monitored_service.up?
        TelegramSubscriber.all.each {|u| u.send_message(gen_message(:down, monitored_service))}
      end
      monitored_service.update!(status: :down, force_create: true) if monitored_service.up?
    else
      avg_delay = delaysum.fdiv(nPings)
      monitored_service.monitored_service_logs.create!(delay: avg_delay, delivery_ratio: del_ratio)
      if Setting.send_email_notifications and monitored_service.down?
        ServiceNotifier.notify_service_event("up", monitored_service).deliver_later!
      end
      if Setting.send_telegram_notifications and monitored_service.down?
        TelegramSubscriber.all.each {|u| u.send_message(gen_message(:up, monitored_service))}
      end
      monitored_service.update!(status: :up, force_create: true) if monitored_service.down?
    end
  end
  
  private
  
  def gen_message status, monitored_service
    status_str = status == :up ? "online" : "offline"
    return "O Serviço #{monitored_service} do dispositivo #{monitored_service.device} está #{status_str}!\nURL: #{monitored_service.url}\nMomento: #{I18n.localize(DateTime.now.in_time_zone, format: :long)}"
  end
end
