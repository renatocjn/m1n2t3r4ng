class StartPingingServicesAsyncJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    MonitoredService.all.each do |service|
      PingServiceJob.perform_later service
    end
  end
end
