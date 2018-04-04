class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!

  self.session_store = :memory_store

  def start(data=nil, *args)
    bot_flow ""
  end

  def message(message, *args)
    bot_flow message['text']
  end

  def action_missing(action, *_args)
    if command?
      respond_with :message, text: "Comando #{action} inválido"
    else
      respond_with :message, text: "Função #{action} inexistente"
    end
  end
  
  private
  
  def bot_flow message
    telegram_subscriber = TelegramSubscriber.find_by_telegram_id(chat["id"])
    if telegram_subscriber.present?
      subscribed_user_flow message, telegram_subscriber
    else
      unsubscribed_user_flow message
    end
  end
  
  def subscribed_user_flow(message, telegram_subscriber)
    if message.present?
      if message == "Sim"
        telegram_subscriber.destroy
        respond_with :message, text: "Voce deixará de receber notificações"
      else
        respond_with :message, text: "Voce continuará a receber notificações"
      end
    else
      respond_with :message, text: "Deseja deixar de receber notificações?", reply_markup: {
        keyboard: [["Sim"], ["Não"]],
        resize_keyboard: true,
        one_time_keyboard: true,
        selective: true,
      }
    end
  end
  
  def unsubscribed_user_flow(message)
    if message.blank?
      respond_with :message, text: "Digite a chave secreta para começar a receber notificações"
    else
      if Setting.private_subscription_key == message
        if chat['type'] == 'group'
          name = chat['title'].to_s
        else
          name = from["first_name"].to_s + " " + from["last_name"].to_s
        end
	name.strip!
        if TelegramSubscriber.create name: name, telegram_id: chat["id"]
          respond_with :message, text: "Usuário registrado"
        else
          respond_with :message, text: "Usuário já registrado"
        end
      else
        respond_with :message, text: "Chave incorreta"
      end
    end
  end
end
