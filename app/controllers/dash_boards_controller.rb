class DashBoardsController < ApplicationController
  def index
    @today_rules = policy_scope(IfThenRule).includes(:reflections).active.select(&:scheduled_today?)
    authorize :dash_board
  end
end
