class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.string :hostname
      t.text :description

      t.timestamps null: false
    end
  end
end
