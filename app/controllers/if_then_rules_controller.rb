class IfThenRulesController < ApplicationController
  def index
  end

  def show
  end

  def new
  @if_then_rule = current_user.if_then_rules.build(memo_id: params[:memo_id])
  end

  def create
    @if_then_rule = current_user.if_then_rules.build(if_then_rule_params)

    if @if_then_rule.save
      redirect_to @if_then_rule, notice: "If-Thenルールを作成しました"
    else
      flash.now[:alert] = "If-Thenルールの作成が失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def if_then_rule_params
    params.require(:if_then_rule)
          .permit(:memo_id, :if_condition, :then_action)
  end
end
