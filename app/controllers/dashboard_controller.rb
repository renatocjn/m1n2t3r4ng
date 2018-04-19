class DashboardController < ApplicationController
  include SetupPanelVariablesConcern
  
  before_filter :authorize
  before_filter :setup_panel_variables, except: [:update_settings, :force_ping]
  
  def services_panel
  end
  
  def update_settings
    error_messages = []
    
    begin
      Setting.max_log_age = Integer(settings_params[:max_log_age]) unless settings_params[:max_log_age].blank?
    rescue ArgumentError
      error_messages << "Tempo máximo de histórico inválido"
    end
    
    begin
      Setting.stabilization_delay = Integer(settings_params[:stabilization_delay]) unless settings_params[:stabilization_delay].blank?
    rescue ArgumentError
      error_messages << "Intervalo de estabilização inválido"
    end
    
    begin
      session[:refresh_rate] = Integer(settings_params[:refresh_ratio]) unless settings_params[:refresh_ratio].blank?
    rescue ArgumentError
      error_messages << "Intervalo de atualização da página inválido"
    end
    
    begin
      Setting.warning_delay = Float(settings_params[:warning_delay])*0.001 unless settings_params[:warning_delay].blank?
    rescue ArgumentError
      error_messages << "Valor inválido para o limiar de alta latência"
    end
    
    Setting.should_notify_warning_status = (settings_params[:should_notify_warning_status] == "true") unless settings_params[:should_notify_warning_status].blank?
    Setting.send_telegram_notifications = (settings_params[:send_telegram_notifications] == "true") unless settings_params[:send_telegram_notifications].blank?
    Setting.send_email_notifications = (settings_params[:send_email_notifications] == "true") unless settings_params[:send_email_notifications].blank?
    Setting.group_services = (settings_params[:group_services] == "true") unless settings_params[:group_services].blank?
    Setting.user_login = settings_params[:user_login] unless settings_params[:user_login].blank?
    Setting.user_passwd = settings_params[:user_passwd] unless settings_params[:user_passwd].blank?
    Setting.notification_email = settings_params[:notification_email] unless settings_params[:notification_email].blank?
    
    respond_to do |format|
      if error_messages.empty?
        format.html { redirect_to :root }
        format.js do 
          if settings_params[:refresh_ratio].blank?
            setup_panel_variables
            render "refresh_panel"
          else
            render partial: "update_refresh_delay"
          end
        end
      else
        format.any {redirect_to :root, alert: error_messages.join("\n")}
      end
    end
  end
  
  def refresh_panel
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def settings_params
    params.require(:setting).permit(:max_log_age, 
                                    :refresh_ratio, 
                                    :warning_delay, 
                                    :n_pings, 
                                    :send_telegram_notifications, 
                                    :send_email_notifications, 
                                    :user_login, :user_passwd, 
                                    :notification_email,
                                    :group_services,
                                    :should_notify_warning_status,
                                    :stabilization_delay
                                    )
  end
end
