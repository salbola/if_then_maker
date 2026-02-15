class ReflectionTimesController < ApplicationController
  def edit
    @user = current_user
    authorize @user
  end
  def update
    @user = current_user
    authorize @user
    @user.update(reflection_time_params)

    redirect_to dash_boards_path, notice: "振り返りタイミングを設定しました"
  end

private

    def reflection_time_params
    params.require(:user).permit(:reflection_time)
  end
end
