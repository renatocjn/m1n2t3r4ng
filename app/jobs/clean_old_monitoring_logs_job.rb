class CleanOldMonitoringLogsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    MonitoredServiceLog.where("created_at <= ?", Setting.max_log_age.seconds).delete_all
  end
end
