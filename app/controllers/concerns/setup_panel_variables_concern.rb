module SetupPanelVariablesConcern
  extend ActiveSupport::Concern

  included do
    helper_method :setup_panel_variables
  end

  def setup_panel_variables 
    if Setting.group_services
      @devices = Device.all.includes(:monitored_services)
    else
      @monitored_services = MonitoredService.all.includes(:device)
    end
    @status_counter = MonitoredService.get_count_of_situations
    @settings = Setting
    @monitored_service ||= MonitoredService.new
    @device ||= Device.new
  end
end