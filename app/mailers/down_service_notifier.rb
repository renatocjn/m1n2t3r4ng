class DownServiceNotifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.down_service_notifier.notify_down_service.subject
  #
  def notify_down_service service
    @service = service
    mail to: "renatoneto@casebras.com.br", subject: "[Monitoramento] Serviço offline #{service.url}"
  end
end
