class CleanOldMonitoringLogsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    MonitoredServiceLog.where("created_at <= ?", Rails.configuration.max_log_age).delete_all
  end
end
