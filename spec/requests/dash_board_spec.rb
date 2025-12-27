require 'rails_helper'

RSpec.describe "DashBoards", type: :request do
  describe "GET /dash_boardsをテストする" do
    context "ログインせずにdash_boardsにアクセスする" do
      it "リダイレクトする" do
      get dash_boards_path
      expect(response).to redirect_to(login_path)
      end
    end
  end
end
