class SessionController < ApplicationController
  before_filter :authorize, only: :destroy
  
  def new
    redirect_to :root if session.include? :user_authorized
  end
  
  def create
    if login_params[:username] == Setting.user_login and login_params[:password] == Setting.user_passwd
      session[:user_authorized] = true
      redirect_to :root, notice: "Bem vindo"
    end
  end
  
  def destroy
    session.delete :user_authorized
    redirect_to login_path, notice: "Até a próxima"
  end
  
  private
  
  def login_params
    params.require(:login).permit(:username, :password)
  end
end
