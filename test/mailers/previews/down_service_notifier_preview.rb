# Preview all emails at http://localhost:3000/rails/mailers/down_service_notifier
class DownServiceNotifierPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/down_service_notifier/notify_down_service
  def notify_down_service
    DownServiceNotifier.notify_down_service MonitoredService.first
  end

end
