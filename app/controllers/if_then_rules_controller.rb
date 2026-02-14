class IfThenRulesController < ApplicationController
  def index
    authorize IfThenRule
    @if_then_rules = policy_scope(IfThenRule)
    @q = @if_then_rules.ransack(params[:q])
    @searched_rules = @q.result.includes(:memo)
    if @if_then_rules.active.length > 3
    flash.now[:warning] = "実行中のルールが少し多いかもしれません。(３つまでを推奨していますが現在 #{@if_then_rules.active.length} つです) "
    end
  end

  def show
    @if_then_rule = policy_scope(IfThenRule).find(params[:id])
    authorize @if_then_rule
  end

  def new
    authorize IfThenRule
    @if_then_rule_form = IfThenRuleForm.new({ memo_id: params[:memo_id] }, user: current_user)
    @active_if_then_rules = policy_scope(IfThenRule).active
    @memo = Memo.find_by(id: @if_then_rule_form.memo_id)
    @step = 2
  end

  def create
    authorize IfThenRule
    @if_then_rule_form = IfThenRuleForm.new(if_then_rule_params, user: current_user)
    @active_if_then_rules = current_user.if_then_rules.active
    @memo = Memo.find_by(id: @if_then_rule_form.memo_id)
    @step = 2
    if @if_then_rule_form.save(ignore_warnings: params[:commit_type] == "ignore_warnings")
      redirect_to @if_then_rule_form.status == "active" ? dash_boards_path : if_then_rules_path, notice: "If-Thenルールを作成しました"
    else
      flash.now[:alert] = "入力内容に問題があります。" if @if_then_rule_form.errors.any?

      flash.now[:warning] = "改善のヒント💡：改善できそうな点があります。内容を確認した上で、このまま保存することもできます。" if @if_then_rule_form.warnings.any?

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @if_then_rule = policy_scope(IfThenRule).find(params[:id])
    authorize @if_then_rule
    @active_if_then_rules = policy_scope(IfThenRule).active

    @if_then_rule_form = IfThenRuleForm.new(user: current_user, if_then_rule_of_model: @if_then_rule)
    @if_then_rule_form.apply_model_to_form
    @memo = Memo.find_by(id: @if_then_rule_form.memo_id)
  end

  def update
    @active_if_then_rules = policy_scope(IfThenRule).active
    @if_then_rule = policy_scope(IfThenRule).find(params[:id])
    authorize @if_then_rule
    @if_then_rule_form = IfThenRuleForm.new(if_then_rule_params, user: current_user, if_then_rule_of_model: @if_then_rule)
    @memo = Memo.find_by(id: @if_then_rule_form.memo_id)

    if @if_then_rule_form.save(ignore_warnings: params[:commit_type] == "ignore_warnings")
      redirect_to if_then_rule_path(@if_then_rule), notice: "If-Thenルールを編集しました"
    else
      flash.now[:alert]  = "入力内容に問題があります。" if @if_then_rule_form.errors.any?
      flash.now[:warning] = "改善のヒント💡：改善できそうな点があります。内容を確認した上で、このまま保存することもできます。" if @if_then_rule_form.warnings.any?
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if_then_rule = policy_scope(IfThenRule).find(params[:id])
    authorize if_then_rule
    if_then_rule.destroy!
    redirect_to if_then_rules_path, notice: "If-Thenルールを削除しました", status: :see_other
  end

  private

  def if_then_rule_params
    params.require(:if_then_rule_form)
          .permit(:memo_id, :if_condition, :then_action, :status)
  end
end
