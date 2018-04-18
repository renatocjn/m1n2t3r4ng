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
      status_str = "está <strong>online &#9989</strong>"
    when "down"
      status_str = "está <strong>offline &#9940</strong>"
    when "warning"
      status_str = "está com <strong>alta latência &#9888</strong>"
    else
      raise ArgumentError.new("Invalid status")
    end
    return "O Serviço <strong>#{monitored_service}</strong> do dispositivo <strong>#{monitored_service.device}</strong> #{status_str}\nURL: #{monitored_service.url}\nMomento: #{I18n.localize(DateTime.now.in_time_zone, format: :long)}"
  end
  
end
