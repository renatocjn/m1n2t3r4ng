class StartPingingServicesJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    logger.info "Start pinging services" 
    MonitoredService.all.each do |service|
      PingServiceJob.perform_later service
    end
    logger.info "Ended pinging services"
  end
end
