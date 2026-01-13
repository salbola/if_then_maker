class DashBoardsController < ApplicationController
  def index
    @if_then_rules = current_user.if_then_rules
  end
end
