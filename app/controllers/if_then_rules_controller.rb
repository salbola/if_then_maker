class IfThenRulesController < ApplicationController
  def index
    @if_then_rules = current_user.if_then_rules.includes(:memo)
  end

  def show
    @if_then_rule = current_user.if_then_rules.find(params[:id])
  end

  def new
    @if_then_rule_form = IfThenRuleForm.new({memo_id: params[:memo_id]}, user: current_user)
  end

  def create
    
    @if_then_rule_form = IfThenRuleForm.new(if_then_rule_params, user: current_user)

    if @if_then_rule_form.valid? && (@if_then_rule_form.warnings.blank? || params[:ignore_warnings])
      @if_then_rule_form.save
      redirect_to if_then_rules_path, notice: "If-Thenルールを作成しました"

    else
      p params[:ignore_warnings]
      p @if_then_rule_form.errors
      flash.now[:alert] = "If-Thenルールの作成が失敗しました"

      render :new, status: :unprocessable_entity
    end
  end

  private

  def if_then_rule_params
    params.require(:if_then_rule_form)
          .permit(:memo_id, :if_condition, :then_action)
  end
end
