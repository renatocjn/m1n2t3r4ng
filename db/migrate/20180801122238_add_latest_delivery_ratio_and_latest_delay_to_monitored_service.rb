class AddLatestDeliveryRatioAndLatestDelayToMonitoredService < ActiveRecord::Migration
  def change
    add_column :monitored_services, :latest_delivery_ratio, :float
    add_column :monitored_services, :latest_delay, :float
  end
end
