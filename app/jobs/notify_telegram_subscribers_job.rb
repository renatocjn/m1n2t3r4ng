class NotifyTelegramSubscribersJob < ActiveJob::Base
  queue_as :default

  def perform(status, service)
    m = gen_message(status, service)
    TelegramSubscriber.all.each do |u|
      u.send_message m
    end
  end
  
  private
  
  def gen_message status, monitored_service
    case status
    when "up"
      status_str = "normalizou"
    when "down"
      status_str = "saiu do ar"
    when "warning"
      status_str = "está com alta latência"
    else
      raise ArgumentError.new("Invalid status")
    end
    return "O Serviço #{monitored_service} do dispositivo #{monitored_service.device} #{status_str}!\nURL: #{monitored_service.url}\nMomento: #{I18n.localize(DateTime.now.in_time_zone, format: :long)}"
  end
  
end
