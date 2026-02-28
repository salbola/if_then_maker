class ReflectionsController < ApplicationController
  include IfThenRulesHelper
  def create
    authorize Reflection
    rule = policy_scope(IfThenRule).find(params[:if_then_rule_id])
    authorize rule
    reflection = rule.reflections.find_or_create_by!(
      user: current_user,
      reflected_on: Date.current
      )
    streams = []

    streams << turbo_stream.replace(
      "today_rules",
      partial: "if_then_rules/dash_boards/today_rules",
      locals: { rules: policy_scope(IfThenRule).active.includes(:reflections).select(&:scheduled_today?) }
    )

    streams << turbo_stream.replace(
      "today_progress",
      partial: "if_then_rules/dash_boards/today_progress",
      locals: { progress: today_progress(policy_scope(IfThenRule).active.includes(:reflections).select(&:scheduled_today?)) }
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
    authorize Reflection
    @reflections = policy_scope(Reflection).includes(:if_then_rule).order(reflected_on: :desc)
  end

  def destroy
  reflection = policy_scope(Reflection).find(params[:id])
  authorize reflection
  reflection.destroy!
    streams = []

    streams << turbo_stream.replace(
      "today_rules",
      partial: "if_then_rules/dash_boards/today_rules",
      locals: { rules: policy_scope(IfThenRule).active.includes(:reflections).select(&:scheduled_today?) }
    )

        streams << turbo_stream.replace(
      "today_progress",
      partial: "if_then_rules/dash_boards/today_progress",
      locals: { progress: today_progress(policy_scope(IfThenRule).active.includes(:reflections).select(&:scheduled_today?)) }
    )
  render turbo_stream: streams, notice: "チェックを取り消ししました"
  end
end
