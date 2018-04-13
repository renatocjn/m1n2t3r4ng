class AddFirstNewStatusTimeToMonitoredService < ActiveRecord::Migration
  def change
    add_column :monitored_services, :new_status_time, :timestamp #NOTE This may help with settings problem folder
  end
end
