class ServiceNotifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.down_service_notifier.notify_down_service.subject
  #
  def notify_service_event status, service
    @service = service
    @status_str = status == :up ? "online" : "offline" 
    mail to: "renatoneto@casebras.com.br", subject: "[Monitoramento] Serviço #{@service} do dispositivo #{@service.device} ficou #{@status_str}"
  end
end
