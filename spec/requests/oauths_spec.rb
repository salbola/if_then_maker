# frozen_string_literal: true

require "rails_helper"

# 以下の2条件が満たされているかを確認するテスト
# - 認証キャンセル: Google承認画面でキャンセル時、クラッシュせずログイン画面に戻りキャンセルメッセージを表示
# - メール重複: メール+パスワード登録済みの同一メールでGoogleログイン時、アカウント統合または明確なエラー表示
RSpec.describe "OAuth Callback", type: :request do
  describe "GET /oauth/callback" do
    context "認証キャンセル時 (Google承認画面でキャンセル)" do
      # NOTE: 実装側で params[:error] を先にチェックし login_path へリダイレクトする必要あり
      it "クラッシュせずログイン画面にリダイレクトし、キャンセルメッセージを表示すること" do
        get "/oauth/callback", params: { provider: "google", error: "access_denied" }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(login_path)
        follow_redirect!
        expect(response.body).to include("キャンセル")
        expect(response.body).to include("ログイン")
      end
    end

    context "メールアドレス重複時（メール+パスワード登録済みの同一メールでGoogleログイン試行）" do
      let!(:existing_user) { create(:user, email: "dup@example.com") }

      before do
        # 外部通信をスタブ: login_from は nil、create_from でメール重複エラー発生→アカウント統合される流れを再現
        allow_any_instance_of(OauthsController).to receive(:login_from).with("google").and_return(nil)
        allow_any_instance_of(OauthsController).to receive(:create_from).with("google") do |controller|
          controller.instance_variable_set(:@user_hash, {
            user_info: { "email" => "dup@example.com" },
            uid: "google-uid-merge-test"
          })
          raise ActiveRecord::RecordNotUnique
        end
      end

      it "既存アカウントと統合されログインできること" do
        get "/oauth/callback", params: { provider: "google", code: "fake_code_for_test" }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        # ログイン済みのため root → dash_boards にリダイレクトされる
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response.body).to include("ログインしました")

        # アカウント統合の確認: 既存ユーザーにGoogle認証が追加されている
        existing_user.reload
        expect(existing_user.authentications.find_by(provider: "google")&.uid).to eq("google-uid-merge-test")
      end
    end
  end
end
