require "rails_helper"

RSpec.describe "UserSessions", type: :request do
  let!(:user) do
    User.create!(
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  describe "POST /login" do
    context "正しい認証情報の場合" do
      it "ログインできてダッシュボードに遷移する" do
        post login_path, params: {
          email: "test@example.com",
          password: "password"
        }

        expect(response).to redirect_to(dash_boards_path)
        follow_redirect!
        expect(response.body).to include("ダッシュボード")
        expect(response.body).to include("ログインが成功しました")
      end
    end

    context "認証に失敗した場合" do
      it "ログインできずログイン画面を再表示する" do
        post login_path, params: {
          email: "test@example.com",
          password: "wrong_passworddddddd!"
        }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("ログインする")
        expect(response.body).to include("ログインが失敗しました")
      end
    end
  end

  describe "DELETE /logout" do
    it "ログアウトして root に遷移する" do
      post login_path, params: {
        email: "test@example.com",
        password: "password"
      }

      delete logout_path

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("仮のランディングページ")
      expect(response.body).to include("ログアウトしました")
    end
  end
end
