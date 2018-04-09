class ServiceNotifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.down_service_notifier.notify_down_service.subject
  #
  def notify_service_event status, service
    @service = service
    case status
    when "up"
      @status_str = "normalizou"
    when "down"
      @status_str = "saiu do ar"
    when "warning"
      @status_str = "está com alta latência"
    else
      raise ArgumentError.new("Invalid status")
    end
    mail to: Setting.notification_email, subject: "[Monitoramento] Mudança de status de serviço"
  end
end
