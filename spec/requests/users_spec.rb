require 'rails_helper'

RSpec.describe "Users", type: :request do
  include LoginHelper
  let(:user) { create(:user) }
  let(:valid_params) do
    {
      user: {
        email: "test@example.com",
        password: "password",
        password_confirmation: "password"
      }
    }
  end
  let(:invalid_params) do
    {
      user: {
        email: "",
        password: "password",
        password_confirmation: "password"
      }
    }
  end


  describe "GET /users (#new) *新規登録画面" do
    context "ログインしている場合" do
      before { login_as(user) }
      it "ダッシュボードへリダイレクトされる" do
        get new_user_path
        expect(response).to redirect_to(dash_boards_path)
        follow_redirect!

        expect(response.body).to include("ダッシュボード")
      end
    end
    context "ログインしていない場合" do
      it "新規登録画面が表示される" do
        get new_user_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("新規登録")
      end
    end
  end


  describe "POST /users (#create) *新規登録" do
  context "ログインしている場合" do
    before { login_as(user) }
    it "ダッシュボードへリダイレクトされる" do
      post users_path, params: {
              user: {
                email: "test@example.com",
                password: "password",
                password_confirmation: "password"
              }
            }
            expect(response).to redirect_to(dash_boards_path)
            follow_redirect!

            expect(response.body).to include("ダッシュボード")
    end
  end
  context "ログインしていない場合" do
      context "正常時" do
        before { post users_path, params: valid_params }

        it "Userが1件増える" do
          expect(User.count).to eq 1
        end

        it "ダッシュボードへリダイレクトされる" do
          expect(response).to redirect_to(dash_boards_path)
        end

        it "成功メッセージが表示される" do
          follow_redirect!
          expect(response.body).to include("ユーザー登録が成功しました")
        end
      end
      context "バリデーションエラー時" do
        before { post users_path, params: invalid_params }
        it "Userは増えない" do
          expect(User.count).to eq 0
        end
        it "422を返す" do
          expect(response).to have_http_status(:unprocessable_content)
        end

        it "新規登録画面を再表示する" do
          expect(response.body).to include("新規登録")
        end

        it "エラーメッセージが表示される" do
          expect(response.body).to include("ユーザー登録が失敗しました")
        end
      end
    end
  end
end
