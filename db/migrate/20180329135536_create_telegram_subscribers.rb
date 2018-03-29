class CreateTelegramSubscribers < ActiveRecord::Migration
  def change
    create_table :telegram_subscribers do |t|
      t.string :name
      t.string :telegram_id

      t.timestamps null: false
    end
  end
end
