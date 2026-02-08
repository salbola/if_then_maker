class IfThenRulesController < ApplicationController
  def index
    @if_then_rules = current_user.if_then_rules.includes(:memo)
    if @if_then_rules.active.length > 3
    flash.now[:warning] = "実行中のルールが少し多いかもしれません。(３つまでを推奨していますが現在 #{@if_then_rules.active.length} つです) "
    end
  end

  def show
    @if_then_rule = current_user.if_then_rules.find(params[:id])
  end

  def new
    @if_then_rule_form = IfThenRuleForm.new({ memo_id: params[:memo_id] }, user: current_user)
    @active_if_then_rules = current_user.if_then_rules.active
    @memo = Memo.find_by(id: @if_then_rule_form.memo_id)
    @step = :step2
  end

  def create
    @if_then_rule_form = IfThenRuleForm.new(if_then_rule_params, user: current_user)
    @active_if_then_rules = current_user.if_then_rules.active
    @memo = Memo.find_by(id: @if_then_rule_form.memo_id)

    if @if_then_rule_form.save(ignore_warnings: params[:commit_type] == "ignore_warnings")
      redirect_to @if_then_rule_form.status == "active" ? dash_boards_path : if_then_rules_path, notice: "If-Thenルールを作成しました"
    else
      flash.now[:alert] = "入力内容に問題があります。" if @if_then_rule_form.errors.any?

      flash.now[:warning] = "改善のヒント💡：改善できそうな点があります。内容を確認した上で、このまま保存することもできます。" if @if_then_rule_form.warnings.any?

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @active_if_then_rules = current_user.if_then_rules.active
    @if_then_rule = current_user.if_then_rules.find(params[:id])

    @if_then_rule_form = IfThenRuleForm.new(user: current_user, if_then_rule_of_model: @if_then_rule)
    @if_then_rule_form.apply_model_to_form
    @memo = Memo.find_by(id: @if_then_rule_form.memo_id)
  end

  def update
    @active_if_then_rules = current_user.if_then_rules.active
    @if_then_rule = current_user.if_then_rules.find(params[:id])
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
  current_user.if_then_rules.find(params[:id]).destroy!
  redirect_to if_then_rules_path, notice: "If-Thenルールを削除しました", status: :see_other
  end

  private

  def if_then_rule_params
    params.require(:if_then_rule_form)
          .permit(:memo_id, :if_condition, :then_action, :status)
  end
end
