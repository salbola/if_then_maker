class IfThenRulesController < ApplicationController
  def index
    @if_then_rules = current_user.if_then_rules.includes(:memo)
  end

  def show
    @if_then_rule = current_user.if_then_rules.find(params[:id])
  end

  def new
    @if_then_rule_form = IfThenRuleForm.new({ memo_id: params[:memo_id] }, user: current_user)
  end

  def create
    @if_then_rule_form = IfThenRuleForm.new(if_then_rule_params, user: current_user)

      if @if_then_rule_form.save(
       ignore_warnings: params[:commit_type] == "ignore_warnings"
     )
        redirect_to if_then_rules_path, notice: "If-Thenルールを作成しました"
      else
        flash.now[:alert] = "入力内容に問題があります。" if @if_then_rule_form.errors.any?

        flash.now[:warning] = "改善できそうな点があります。内容を確認してみてください。" if @if_then_rule_form.warnings.any?

        render :new, status: :unprocessable_entity
      end
  end

  def edit
    @if_then_rule = current_user.if_then_rules.find(params[:id])

    @if_then_rule_form = IfThenRuleForm.new(user: current_user,if_then_rule_of_model: @if_then_rule )
    @if_then_rule_form.apply_model_to_form
  end

  def update
    @if_then_rule = current_user.if_then_rules.find(params[:id])
    @if_then_rule_form = IfThenRuleForm.new(if_then_rule_params, user: current_user,if_then_rule_of_model: @if_then_rule)

  end

  private

  def if_then_rule_params
    params.require(:if_then_rule_form)
          .permit(:memo_id, :if_condition, :then_action)
  end
end
