class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to '/login', alert: "Por favor, entre com seu usuário" unless current_user.present?
  end
  
  def gen_error_string record
    record.errors.collect {|err, msg| msg}.join("\n")
  end
end
