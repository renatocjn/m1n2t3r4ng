class StartPingingServicesJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    MonitoredService.all.each do |service|
      PingServiceJob.perform_now service
    end
  end
end
