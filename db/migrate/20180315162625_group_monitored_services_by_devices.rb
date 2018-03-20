class GroupMonitoredServicesByDevices < ActiveRecord::Migration
  def change
    add_reference :monitored_services, :device, index: true, foreign_key: true
    remove_column :monitored_services, :host
  end
end
