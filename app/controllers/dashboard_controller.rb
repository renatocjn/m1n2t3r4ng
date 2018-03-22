class DashboardController < ApplicationController
  before_filter :authorize
  
  def services_panel
    setup_panel_variables
  end
  
  def update_settings
    error_messages = []
    
    begin
      Setting.max_log_age = Integer(settings_params[:max_log_age].strip) unless settings_params[:max_log_age].blank?
    rescue ArgumentError
      error_messages << "Tempo máximo de histórico inválido"
    end
    
    begin
      Setting.refresh_ratio = Integer(settings_params[:refresh_ratio].strip) unless settings_params[:refresh_ratio].blank?
    rescue ArgumentError
      error_messages << "Tempo máximo de histórico inválido"
    end
    
    begin
      Setting.warning_delay = Float(settings_params[:warning_delay].strip) unless settings_params[:warning_delay].blank?
    rescue ArgumentError
      error_messages << "Duração de latência inválida"
    end
    
    Setting.send_telegram_notifications = (settings_params[:send_telegram_notifications].strip == "true") unless settings_params[:send_telegram_notifications].blank?
    Setting.send_email_notifications = (settings_params[:send_email_notifications].strip == "true") unless settings_params[:send_email_notifications].blank?
    Setting.group_services = (settings_params[:group_services].strip == "true") unless settings_params[:group_services].blank?
    Setting.user_login = settings_params[:user_login].strip unless settings_params[:user_login].blank?
    Setting.user_passwd = settings_params[:user_passwd].strip unless settings_params[:user_passwd].blank?
    Setting.notification_email = settings_params[:notification_email].strip unless settings_params[:notification_email].blank?
    
    respond_to do |format|
      if error_messages.empty?
        format.html {redirect_to :root, notice: "Configurações atualizadas"}
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
      setup_panel_variables
      format.js
    end
  end
  
  def force_ping
    StartPingingServicesJob.perform_now
    setup_panel_variables
    render "refresh_panel"
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
                                    :group_services
                                    )
  end
  
  def setup_panel_variables 
    if Setting.group_services
      @devices = Device.all.includes(:monitored_services)
    else
      @monitored_services = MonitoredService.all.includes(:device)
    end
    logger.debug @monitored_services
    @status_counter = MonitoredService.get_count_of_situations
    @settings = Setting
    @monitored_service ||= MonitoredService.new
    @device ||= Device.new
  end
end
