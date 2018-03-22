class PingServiceJob < ActiveJob::Base
  queue_as :default

  def perform(monitored_service)
    nPings = Setting.n_pings
    pings = nPings.times.collect{monitored_service.execute_single_ping}.compact
    delaysum = pings.reduce(:+)
    del_ratio = pings.length.fdiv(nPings)
    if delaysum == nil
      monitored_service.monitored_service_logs.create!(delivery_ratio: del_ratio)
      if Setting.send_email_notifications and (monitored_service.up? or monitored_service.status.nil?)
        ServiceNotifier.notify_service_event(:down, monitored_service).deliver_now
      end
      if Setting.send_telegram_notifications and (monitored_service.up? or monitored_service.status.nil?)
        TeleNotify::TelegramUser.all.each {|u| u.send_message(gen_message(:down, monitored_service))}
      end
      monitored_service.update! status: :down if monitored_service.up? or monitored_service.status.nil?
    else
      avg_delay = delaysum.fdiv(nPings)
      monitored_service.monitored_service_logs.create!(delay: avg_delay, delivery_ratio: del_ratio)
      if Setting.send_email_notifications and (monitored_service.down? or monitored_service.status.nil?)
        ServiceNotifier.notify_service_event(:up, monitored_service).deliver_now
      end
      if Setting.send_telegram_notifications and (monitored_service.down? or monitored_service.status.nil?)
        TeleNotify::TelegramUser.all.each {|u| u.send_message(gen_message(:up, monitored_service))}
      end
      monitored_service.update! status: :up if monitored_service.down? or monitored_service.status.nil?
    end
  end
  
  def gen_message status, monitored_service
    status_str = status == :up ? "online" : "offline"
    return "O Serviço #{monitored_service} do dispositivo #{monitored_service.device} está #{status_str}!\nURL: #{monitored_service.url}\nMomento: #{I18n.localize(DateTime.now.in_time_zone, format: :long)}"
  end
end
