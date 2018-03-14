class PingServiceJob < ActiveJob::Base
  queue_as :default

  def perform(monitored_service)
    nPings = 30
    pings = nPings.times.collect{monitored_service.execute_single_ping}.compact
    delaysum = pings.reduce(:+)
    del_ratio = pings.length.fdiv(nPings)
    if delaysum == nil
      monitored_service.monitored_service_logs.create!(delivery_ratio: del_ratio)
    else
      avg_delay = delaysum.fdiv(nPings)
      monitored_service.monitored_service_logs.create!(delay: avg_delay, delivery_ratio: del_ratio)
    end
  end
end
