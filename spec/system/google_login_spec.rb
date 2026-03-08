# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Google Login", type: :system do
  # 外部通信をスタブ: 実際のGoogle OAuthには接続せず、ダミーデータで認証をシミュレート
  before do
    # 1. login_at の代わりにコールバックURLへ直接リダイレクト（Googleへの外部リダイレクトを回避）
    allow_any_instance_of(OauthsController).to receive(:login_at) do |instance, provider|
      instance.redirect_to "/oauth/callback?provider=#{provider}"
    end
  end

  context "既存ユーザーの場合" do
    let!(:user) { create(:user, email: "test@example.com") }
    let!(:authentication) { create(:authentication, user: user, provider: "google", uid: "google-uid-12345") }

    before do
      # 2. login_from をスタブ: 外部API呼び出しを行わず、ダミーユーザーを返す
      allow_any_instance_of(OauthsController).to receive(:login_from).with("google") do |controller|
        controller.auto_login(user) # 飛ばすべきではないログイン処理をおこなってセッションが作られる
        user # 戻り値として user を返す(整合性)
      end
    end

    it "Google連携でログインできること" do
      visit login_path
      click_link "Googleでログイン"

      expect(page).to have_content "ログインしました"
    end
  end

  context "新規ユーザーの場合" do
    let(:new_user) { create(:user, email: "newuser@example.com") }

    before do
      # login_from は nil（既存ユーザーなし）、create_from で新規ユーザーを作成
      allow_any_instance_of(OauthsController).to receive(:login_from).with("google").and_return(nil)
      allow_any_instance_of(OauthsController).to receive(:create_from).with("google").and_return(new_user)
    end

    it "Google連携で新規登録・ログインできること" do
      visit login_path
      click_link "Googleでログイン"

      expect(page).to have_content "ログインしました"
    end
  end
end
