require 'rails_helper'

RSpec.describe "DashBoards", type: :request do
  let (:user) { create(:user) }
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
