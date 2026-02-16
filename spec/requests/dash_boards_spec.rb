require 'rails_helper'

RSpec.describe "DashBoards", type: :request do
  let (:user) { create(:user) }
  let (:other_user) { create(:user) }
  let!(:rule) { create(:if_then_rule, user: user, status: :active, if_condition: "my rule") }
  let!(:other_rule) { create(:if_then_rule, user: other_user, status: :active, if_condition: "other rule") }
  include LoginHelper
  describe "GET /dash_boards" do
    context "ログインしている場合" do
      before do
        login_as(user)
        get dash_boards_path
      end
      it "ダッシュボードが表示される" do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("ダッシュボード")
      end
      it "自分の今日の(activeの)ルールは表示される" do
        expect(response.body).to include("my rule")
      end

      it "他人の今日の(activeの)ルールは表示されない" do
        expect(response.body).not_to include("other rule")
      end
    end
    context "ログインせずにdash_boardsにアクセスする" do
      it "ログイン画面へリダイレクトする" do
      get dash_boards_path
      expect(response).to redirect_to(login_path)
      follow_redirect!
      expect(response.body).to include("ログインしてください")
      end
    end
  end
end
