class AddDeliveryRatioToMonitoredServiceLog < ActiveRecord::Migration
  def change
    add_column :monitored_service_logs, :delivery_ratio, :float
  end
end
