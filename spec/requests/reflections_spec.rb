require "rails_helper"
RSpec.describe "Reflections", type: :request do
  let(:user) { create(:user) }
  let(:memo) { create(:memo, user: user) }
  let(:rule) { create(:if_then_rule, user: user, memo: memo, status: 1) }
  include LoginHelper
  before { login_as(user) }

  it "チェックボタンで今日の日付でreflectionが作成できる" do
    expect {
      post if_then_rule_reflections_path(if_then_rule_id: rule.id)
    }.to change { Reflection.count }.by(1)

    reflection = Reflection.last
    expect(reflection.reflected_on).to eq Date.current
  end

  it "チェックボタンを2回押しても今日の日付のreflectionが2つはできないこと" do
    post if_then_rule_reflections_path(if_then_rule_id: rule.id)

    expect {
      post if_then_rule_reflections_path(if_then_rule_id: rule.id)
    }.not_to change { Reflection.count }
  end
end
