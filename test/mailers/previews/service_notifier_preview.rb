# Preview all emails at http://localhost:3000/rails/mailers/down_service_notifier
class ServiceNotifierPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/service_notifier/notify_service_event
  def notify_service_event
    ServiceNotifier.notify_service_event :up, MonitoredService.first
  end

end
