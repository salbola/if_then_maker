class IfThenRules::FlowsController < ApplicationController
  def step1
     @memos = current_user.memos.order(created_at: :desc)
  end

  def step1_submit
  end

  def step2
  end

  def step2_submit
  end

  def step3
  end

  def step3_submit
  end
end
