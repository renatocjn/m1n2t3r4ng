class DashboardController < ApplicationController
  before_filter :authorize
  
  def services_panel
    @monitored_service ||= MonitoredService.new
    @monitored_services = MonitoredService.all
  end
end
