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
        # 外部通信をスタブ: login_from は nil、create_from 実行時に重複エラーが発生する状況を再現
        allow_any_instance_of(OauthsController).to receive(:login_from).with("google").and_return(nil)
        allow_any_instance_of(OauthsController).to receive(:create_from).with("google")
          .and_raise(ActiveRecord::RecordNotUnique)
      end

      it "クラッシュせず適切に処理されること（アカウント統合または明確なエラー表示）" do
        get "/oauth/callback", params: { provider: "google", code: "fake_code_for_test" }

        # 500エラーにならないこと
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        # アカウント統合されログイン成功 OR 明確なエラーメッセージのいずれか
        expect(response.body).to match(/ログインしました|ログインに失敗/)
      end
    end
  end
end
