class DashBoardsController < ApplicationController
  def index
    @if_then_rules = policy_scope(IfThenRule)
    authorize :dash_board
  end
end
