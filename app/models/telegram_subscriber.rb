class TelegramSubscriber < ActiveRecord::Base
    validates :name, :telegram_id, presence: true
    validates :telegram_id, uniqueness: true
    
    def send_message txt
        Telegram.bot.send_message chat_id: self.telegram_id, text: txt
    end
end
