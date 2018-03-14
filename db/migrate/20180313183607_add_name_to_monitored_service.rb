class AddNameToMonitoredService < ActiveRecord::Migration
  def change
    add_column :monitored_services, :name, :string
  end
end
