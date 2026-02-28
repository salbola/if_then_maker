class DashBoardsController < ApplicationController
  def index
    @today_rules = policy_scope(IfThenRule).active.select(&:scheduled_today?)
    puts "------------ids--------------------"
    p @today_rules.map(&:id)
    authorize :dash_board
  end
end
