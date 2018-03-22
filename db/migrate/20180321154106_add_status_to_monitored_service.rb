class AddStatusToMonitoredService < ActiveRecord::Migration
  def change
    add_column :monitored_services, :status, :integer
  end
end
