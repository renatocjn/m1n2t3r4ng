class PingServiceJob < ActiveJob::Base
  queue_as :default

  def perform(monitored_service)
    nPings = Rails.configuration.nPings
    pings = nPings.times.collect{monitored_service.execute_single_ping}.compact
    delaysum = pings.reduce(:+)
    del_ratio = pings.length.fdiv(nPings)
    if delaysum == nil
      monitored_service.monitored_service_logs.create!(delivery_ratio: del_ratio)
      if Rails.configuration.send_emails_on_down_ping
        DownServiceNotifier.notify_down_service(monitored_service).deliver_now
      end
    else
      avg_delay = delaysum.fdiv(nPings)
      monitored_service.monitored_service_logs.create!(delay: avg_delay, delivery_ratio: del_ratio)
    end
  end
end
