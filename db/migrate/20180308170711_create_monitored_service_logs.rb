class CreateMonitoredServiceLogs < ActiveRecord::Migration
  def change
    create_table :monitored_service_logs do |t|
      t.references :monitored_service, index: true, foreign_key: true
      t.float :delay

      t.timestamps null: false
    end
  end
end
