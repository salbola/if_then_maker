require "rails_helper"
RSpec.describe "Reflections", type: :request do
  let(:user) { create(:user) }
  let(:memo) { create(:memo, user: user) }
  let(:rule) { create(:if_then_rule, user: user, memo: memo, status: :active) }
  include LoginHelper
  describe "POST /if_then_rules/:if_then_rule_id/reflections (#create)" do
  context "ログインしていない場合" do
    it "ログイン画面へリダイレクトされる" do
      post if_then_rule_reflections_path(if_then_rule_id: rule.id)
      expect(response).to redirect_to(login_path)
      follow_redirect!
      expect(response.body).to include("ログインしてください")
    end
  end

  context "ログイン済みの場合" do
    before { login_as(user) }

    it "チェックボタンで今日の日付のreflectionが作成できる" do
      expect {
        post if_then_rule_reflections_path(if_then_rule_id: rule.id)
      }.to change(Reflection, :count).by(1)

      reflection = Reflection.last
      expect(reflection.reflected_on).to eq Date.current
    end

    it "チェックボタンを2回押しても今日の日付のreflectionが2つは作成されない" do
      post if_then_rule_reflections_path(if_then_rule_id: rule.id)

      expect {
        post if_then_rule_reflections_path(if_then_rule_id: rule.id)
      }.not_to change(Reflection, :count)
    end
  end
  end
  describe "GET /reflections (#index)" do
  context "ログインしていない場合" do
    it "ログイン画面へリダイレクトされる" do
      get reflections_path
      expect(response).to redirect_to(login_path)
    end
  end

  context "ログイン済みの場合" do
    before { login_as(user) }

    it "振り返り一覧が表示される" do
      get reflections_path
      expect(response).to have_http_status(:ok)
    end
  end
end

describe "DELETE /if_then_rules/:if_then_rule_id/reflections/:id (#destroy)" do
  let!(:reflection) do
    create(:reflection, user: user, if_then_rule: rule, reflected_on: Date.current)
  end

  context "ログインしていない場合" do
    it "ログイン画面へリダイレクトされる" do
      delete if_then_rule_reflection_path(rule, reflection)
      expect(response).to redirect_to(login_path)
    end
  end

  context "ログイン済みの場合" do
    before { login_as(user) }

    it "reflectionを削除できる" do
      expect {
        delete if_then_rule_reflection_path(rule, reflection)
      }.to change(Reflection, :count).by(-1)
    end
  end
end
end
