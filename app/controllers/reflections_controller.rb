class ReflectionsController < ApplicationController
  include IfThenRulesHelper
  def create
    rule = current_user.if_then_rules.find(params[:if_then_rule_id])
    
    reflection = rule.reflections.find_or_create_by!(
      user: current_user,
      reflected_on: Date.current
      )
    streams = []

    streams << turbo_stream.replace(
      "today_rules",
      partial: "if_then_rules/today_rules",
      locals: { rules: current_user.if_then_rules }
    )

    streams << turbo_stream.replace(
      "today_progress",
      partial: "if_then_rules/today_progress",
      locals: { progress: today_progress(current_user.if_then_rules) }
    )

    if current_user.all_rules_completed_today?
      streams << turbo_stream.replace(
        "modal",
        partial: "shared/celebrate_modal"
      )
    end

    render turbo_stream: streams
  end

  def index
    @reflections = current_user.reflections.includes(:if_then_rule).order(reflected_on: :desc)
  end

  def destroy
  reflection = current_user.reflections.find(params[:id])
  reflection.destroy!
    streams = []

    streams << turbo_stream.replace(
      "today_rules",
      partial: "if_then_rules/today_rules",
      locals: { rules: current_user.if_then_rules }
    )

        streams << turbo_stream.replace(
      "today_progress",
      partial: "if_then_rules/today_progress",
      locals: { progress: today_progress(current_user.if_then_rules) }
    )
  render turbo_stream: streams, notice: "チェックを取り消ししました"
  end
end
