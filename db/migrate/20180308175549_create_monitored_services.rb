class CreateMonitoredServices < ActiveRecord::Migration
  def change
    create_table :monitored_services do |t|
      t.integer :service_type
      t.string :host
      t.integer :port
      t.text :description

      t.timestamps null: false
    end
  end
end
