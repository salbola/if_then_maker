class MemosController < ApplicationController
  def index
    @memos = current_user.memos
    @q = @memos.ransack(params[:q])
    @searched_memos = @q.result(distinct: true)
  end

  def stale
    @memos = current_user.memos
    @searched_memos = @memos.stale
  end

  def new
    @memo = current_user.memos.build
    @from_rule_flow = params[:from] == "rule_flow"
  end

  def create
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
    @memo = current_user.memos.find(params[:id])
    @from_rule_flow = params[:from] == "rule_flow"
  end

  def edit
    @memo = current_user.memos.find(params[:id])
  end

  def update
    @memo = current_user.memos.find(params[:id])
    if @memo.update(memo_params)
      redirect_to @memo, notice: "メモの更新が成功しました"
    else
      flash.now[:alert] = "メモの更新が失敗しました"
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    current_user.memos.find(params[:id]).destroy!
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
