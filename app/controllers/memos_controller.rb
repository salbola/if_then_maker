class MemosController < ApplicationController
  def index
    @memos = current_user.memos
  end

  def new
  end

  def create
    
  end

  def show
  end

  def edit
  end

  def update
    
  end

  def destroy
    
  end
end
