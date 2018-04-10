class AddFirstNewStatusTimeToMonitoredService < ActiveRecord::Migration
  def change
    add_column :monitored_services, :new_status_time, :timestamp
  end
end
