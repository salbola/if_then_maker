require 'rails_helper'

RSpec.describe "Reflection_times", type: :request do
  let(:user) { create(:user, password: "password") }
  let(:memo) { create(:memo, user: user) }
  let(:if_then_rule) {create(:if_then_rule, user: user, memo: memo, status: :active)}
    include LoginHelper
  describe "GET /reflection_time/editをテストする" do
    context "ログインせずにreflection_timeにアクセスする" do
      it "ログイン画面へリダイレクトする" do
      get edit_reflection_time_path
      expect(response).to redirect_to(login_path)
      follow_redirect!
      expect(response.body).to include("ログインしてください")
      end
    end
  end
  describe "GET /reflection_time/updateをテストする" do
    context "ログインせずにreflection_timeにアクセスする" do
      it "ログイン画面へリダイレクトする" do
      patch reflection_time_path
      expect(response).to redirect_to(login_path)
      follow_redirect!
      expect(response.body).to include("ログインしてください")
      end
    end
    context "ログイン済みで正しい値の場合" do
      it "振り返りタイミングの編集が成功する" do
        login_as(user)
        reflection_time = Time.current
        patch reflection_time_path, params: {
          user: {
          reflection_time: reflection_time.to_s
        }
        }
        expect(response).to redirect_to(dash_boards_path)
        follow_redirect!
        expect(response.body).to include("振り返りタイミングを設定しました")

      end
      it "activeのルールが存在すれば振り返りタイミングが表示される" do
        login_as(user)
        if_then_rule
        reflection_time = Time.current
        patch reflection_time_path, params: {
          user: {
          reflection_time: reflection_time.to_s
        }
        }
        expect(response).to redirect_to(dash_boards_path)
        follow_redirect!
        expect(response.body).to include("振り返りタイミングを設定しました")
        expect(response.body).to include(reflection_time&.strftime("%H:%M"))
      end
    end
  end
end
