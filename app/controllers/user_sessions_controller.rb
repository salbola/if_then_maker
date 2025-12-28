class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :redirect_if_logged_in, only: [:new, :create]
  def new
    @user = User.new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to dash_boards_path, notice: "ログインが成功しました"
    else
      flash.now[:alert] = "ログインが失敗しました"
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    logout
    redirect_to root_path, status: :see_other, notice: "ログアウトしました"
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation
    )
  end
  
  def redirect_if_logged_in
    redirect_to dash_boards_path if logged_in?
  end
end
