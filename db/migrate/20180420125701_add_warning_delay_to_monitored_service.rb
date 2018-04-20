class AddWarningDelayToMonitoredService < ActiveRecord::Migration
  def change
    add_column :monitored_services, :warning_delay, :float
    
    MonitoredService.update_all warning_delay: Setting.default_warning_delay
  end
end
