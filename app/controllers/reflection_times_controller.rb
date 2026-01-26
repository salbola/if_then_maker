class ReflectionTimesController < ApplicationController
  def edit
  end
  def update
    current_user.update(reflection_time_params)
    redirect_to dash_boards_path, notice: "振り返りタイミングを設定しました"
  end


    def reflection_time_params
    params.require(:user).permit(:reflection_time)
  end
end
