class MemosController < ApplicationController
  def index
    @memos = current_user.memos
  end

  def new
    @memo = current_user.memos.build
  end

  def create
    @memo = current_user.memos.build(memo_params)
    if @memo.save
      redirect_to memos_path, notice: "メモの作成が成功しました"
    else
      flash.now[:alert] = "メモの作成が失敗しました"
      render :new, status: :unprocessable_content
    end
  end

  def show
    @memo = current_user.memos.find(params[:id])
  end

  def edit
  end

  def update
    
  end

  def destroy
    
  end

  private

  def memo_params
    params.require(:memo).permit(
      :title,
      :body
    )
  end
end
