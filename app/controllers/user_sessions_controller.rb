class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  def new
    @user = User.new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to dash_boards_path
    else
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    logout
    redirect_to root_path ,status: :see_other
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation
    )
  end
end
