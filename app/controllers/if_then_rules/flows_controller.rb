class IfThenRules::FlowsController < ApplicationController
  def step1
    authorize IfThenRule, :create?
    @memos = policy_scope(Memo).order(created_at: :desc)
    @step = 1
  end

  # def step1_submit
  # end

  # def step2
  # end

  # def step2_submit
  # end

  # def step3
  # end

  # def step3_submit
  # end
end
