require 'rails_helper'

RSpec.describe "DashBoards", type: :request do
  describe "GET /dash_boardsをテストする" do
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
