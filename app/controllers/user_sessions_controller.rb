class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :redirect_if_logged_in, only: [ :new, :create ]
  def new
  end

  def create
    user = login(session_params[:email], session_params[:password], session_params[:remember_me])
    
    if user
      remember_me!
      redirect_to dash_boards_path, notice: "ログインが成功しました"
    else
      flash.now[:alert] = "ログインが失敗しました"
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    forget_me!
    logout
    redirect_to root_path, status: :see_other, notice: "ログアウトしました"
  end

  private

  def redirect_if_logged_in
    redirect_to dash_boards_path if logged_in?
  end

  def session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end
end
