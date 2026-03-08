class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  # プロバイダーへの認証リダイレクト
  def oauth
    # これによりユーザーがgoogleへリダイレクトして本人確認の同意とかをする
    login_at(params[:provider])
  end

  # OAuth コールバック処理
  def callback
    provider = params[:provider]
    # 認証でキャンセルした時の処理
    if params[:error] == "access_denied"
      redirect_to login_path, alert: "#{provider.titleize}からのログインをキャンセルしました"
    else
    # 通常の処理
      if @user = login_from(provider)
        redirect_to root_path, notice: "#{provider.titleize}でログインしました！"
      else
        begin
          @user = create_from(provider)
          reset_session
          auto_login(@user)
          redirect_to root_path, notice: "#{provider.titleize}でログインしました！"
        rescue StandardError => e
          logger.error "OAuth Error: #{e.message}"
          redirect_to root_path, alert: "#{provider.titleize}からのログインに失敗しました"
        end
      end
    end
  end
end
