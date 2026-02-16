require 'rails_helper'

RSpec.describe "Reflection_times", type: :request do
  let(:user) { create(:user, password: "password") }
  let(:memo) { create(:memo, user: user) }
  # let(:if_then_rule) { create(:if_then_rule, user: user, memo: memo, status: :active) }
  let!(:reflection_time) { Time.current }
    include LoginHelper
  describe "GET /reflection_time/edit (#editのテスト)" do
  context "ログイン済みの場合" do
    before do
      login_as(user)
      get edit_reflection_time_path
    end
    it "編集画面が表示される" do
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("振り返り時刻編集")
    end
  end
    context "ログインしていない場合" do
      it "ログイン画面へリダイレクトする" do
      get edit_reflection_time_path
      expect(response).to redirect_to(login_path)
      follow_redirect!
      expect(response.body).to include("ログインしてください")
      end
    end
  end
  describe "PATCH /reflection_time/ (#updateのテスト)" do
  context "ログイン済みの場合" do
    before { login_as(user) }

    context "activeのルールが存在しない場合" do
      before do
        patch reflection_time_path, params: {
          user: { reflection_time: reflection_time.to_s }
        }
      end

      it "振り返りタイミングの編集が成功する" do
        expect(response).to redirect_to(dash_boards_path)
      end
    end

    context "activeのルールが存在する場合" do
      let!(:if_then_rule) { create(:if_then_rule, user: user, memo: memo, status: :active) }
      # patchの実行前にactiveなルールが存在している状態にする。
      before do
        patch reflection_time_path, params: {
          user: { reflection_time: reflection_time.to_s }
        }
      end

      it "ダッシュボードに設定時刻が表示される" do
        follow_redirect!
        expect(response.body).to include(reflection_time.strftime("%H:%M"))
      end
    end
  end
    context "ログインしていない場合" do
      it "ログイン画面へリダイレクトする" do
      patch reflection_time_path
      expect(response).to redirect_to(login_path)
      follow_redirect!
      expect(response.body).to include("ログインしてください")
      end
    end
  end
end
