require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users系をテストする" do
    context "正常系" do
      it "ユーザー登録に成功でUserの数が増える,成功ダッシュボードに遷移するリダイレクトが帰ってくる" do
        expect {
          post users_path, params: {
            user: {
              email: "test@example.com",
              password: "password",
              password_confirmation: "password"
            }
          }
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(dash_boards_path)
        follow_redirect!

        expect(response.body).to include("ダッシュボード")
      end
    end
          context "異常系" do
      it "バリデーションエラー時は数が増えず、新規登録画面を再表示する" do
        expect {
          post users_path, params: {
            user: {

              email: "",
              password: "password",
              password_confirmation: "password"
            }
          }
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("新規登録")
      end
    end
  end
end
