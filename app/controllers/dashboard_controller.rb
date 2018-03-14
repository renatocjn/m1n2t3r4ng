class DashboardController < ApplicationController
  before_filter :authorize
  
  def services_panel
    @monitored_service ||= MonitoredService.new
    @monitored_services = MonitoredService.all
  end
  
  def update_refresh_delay
    Rails.configuration.refresh_ratio = Integer(params[:update_refresh_delay][:seconds]).seconds
    render partial: "update_refresh_delay.js"
  end
  
  def update_warning_delay
    new_seconds = Float(params[:update_warning_delay][:seconds])
    Rails.configuration.warning_delay = new_seconds.seconds
    @monitored_services = MonitoredService.all
    render "refresh_panel"
  end
  
  def refresh_panel
    respond_to do |format|
      @monitored_services = MonitoredService.all
      format.js
    end
  end
  
  def force_ping
    StartPingingServicesJob.perform_now
    @monitored_services = MonitoredService.all
    render "refresh_panel"
  end
end
