class MemosController < ApplicationController
  def index
    authorize Memo
    @memos = policy_scope(Memo)
    @q = @memos.ransack(params[:q])
    @searched_memos = @q.result(distinct: true)
  end

  def stale
    authorize Memo
    @memos = policy_scope(Memo)
    @searched_memos = @memos.stale(days = 7)
  end

  def new
    authorize Memo
    @memo = current_user.memos.build
    @from_rule_flow = params[:from] == "rule_flow"
  end

  def create
    authorize Memo
    @memo = current_user.memos.build(memo_params)
    @from_rule_flow = params[:memo][:from] == "rule_flow"
    if @memo.save
      redirect_to memo_path(@memo, from: "rule_flow"), notice: "メモの作成が成功しました"
    else
      flash.now[:alert] = "メモの作成が失敗しました"
      render :new, status: :unprocessable_content
    end
  end

  def show
    @memo = policy_scope(Memo).find(params[:id])
    authorize @memo
    @from_rule_flow = params[:from] == "rule_flow"
  end

  def edit
    @memo = policy_scope(Memo).find(params[:id])
    authorize @memo
  end

  def update
    @memo = policy_scope(Memo).find(params[:id])
    authorize @memo
    if @memo.update(memo_params)
      redirect_to @memo, notice: "メモの更新が成功しました"
    else
      flash.now[:alert] = "メモの更新が失敗しました"
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    memo = policy_scope(Memo).find(params[:id])
    authorize memo
    memo.destroy!
    redirect_to memos_path, status: :see_other, notice: "メモを削除しました"
  end

  private

  def memo_params
    params.require(:memo).permit(
      :title,
      :body,
    )
  end
end
