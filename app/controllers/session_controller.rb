class SessionController < ApplicationController
  before_filter :authorize, only: :destroy
  before_filter :redirect_already_authed, except: :destroy
  
  def new
  end
  
  def create
    if login_params[:username] == Setting.user_login and login_params[:password] == Setting.user_passwd
      session[:user_authorized] = true
      session[:refresh_rate] ||= Setting.refresh_rate
      redirect_to :root
    elsif login_params[:username] != Setting.user_login and login_params[:password] != Setting.user_passwd
      redirect_to login_path, Alert: "Usuário e senha incorretos"
    elsif login_params[:username] != Setting.user_login
      redirect_to login_path, Alert: "Usuário incorreto"
    elsif login_params[:password] != Setting.user_passwd
      redirect_to login_path, Alert: "Senha incorreta"
    end
  end
  
  def destroy
    session.delete :user_authorized
    redirect_to login_path
  end
  
  private
  
  def login_params
    params.require(:login).permit(:username, :password)
  end
  
  def redirect_already_authed
    redirect_to :root if session.include? :user_authorized
  end
end
