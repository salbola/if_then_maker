class ReflectionsController < ApplicationController
  def create
    rule = current_user.if_then_rules.find(params[:if_then_rule_id])

    reflection = rule.reflections.find_or_create_by!(
      user: current_user,
      reflected_on: Date.current
    )
    redirect_back fallback_location: dash_boards_path
  end
end
