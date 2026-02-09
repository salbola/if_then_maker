class TrialsController < ApplicationController
  skip_before_action :require_login, only: %i[new create show]
  before_action :redirect_if_logged_in, only: %i[ new create show]


  def new
    @trial_rule_form = TrialRuleForm.new()
    # @memo = Memo.find_by(id: @trial_rule_form.memo_id)
    @step = 2
  end

  def create
    @trial_rule_form = TrialRuleForm.new(trial_rule_params)
    # @memo = Memo.find_by(id: @trial_rule_form.memo_id)
    @step = 2
    if @trial_rule_form.savable?(ignore_warnings: params[:commit_type] == "ignore_warnings")
      flash.now[:notice] = "If-Thenルールを作成しました(!お試しなので保存はしていません)"
      render :show
    else
      flash.now[:alert] = "入力内容に問題があります。" if @trial_rule_form.errors.any?

      flash.now[:warning] = "改善のヒント💡：改善できそうな点があります。内容を確認した上で、このまま進めることもできます。" if @trial_rule_form.warnings.any?

      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def redirect_if_logged_in
    redirect_to dash_boards_path if logged_in?
  end

  def trial_rule_params
    params.require(:trial_rule_form)
          .permit(:memo_id, :if_condition, :then_action, :status)
  end
end
