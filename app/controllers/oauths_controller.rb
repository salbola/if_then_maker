class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  # プロバイダーへの認証リダイレクト
  def oauth
    # これによりユーザーがgoogleへリダイレクトして本人確認の同意とかをするように指示のレスポンスを返す
    login_at(params[:provider])
  end

  # OAuth コールバック処理
  def callback
    provider = params[:provider]
    if params[:error] == "access_denied"
      # ユーザーがGoogleの認証の許可画面でキャンセルした時の処理
      redirect_to login_path, alert: "#{provider.titleize}からのログインをキャンセルしました"
    else
      # ユーザーが普通に認証許可した場合は通常の処理へ
      # login_fromは外部認証のユーザが見当たらない場合nilやfalseを返すらしい->新規登録の可能性があるためエラーを返さない設計。
      if @user = login_from(provider)
        # 普通にoauthでのログインができた場合はダッシュボードへ
        redirect_to dash_boards_path, notice: "#{provider.titleize}でログインしました！"
      else
        begin
          # oauthでのログインができなかった場合は
          # oauthでのユーザーを作りログインする
          # create_fromは失敗の際エラーを返す
          @user = create_from(provider)
          reset_session
          auto_login(@user)
          redirect_to dash_boards_path, notice: "#{provider.titleize}でログインしました！"
        rescue ActiveRecord::RecordNotUnique => e
          # すでにパスワードで作成した同じメールアドレスのユーザーがある場合
          # oauthでのユーザー新規作成に失敗した場合
          merge_existing_account_or_fail(provider, e)
        rescue StandardError => e
          # それ以外の予期しないエラーの場合
          logger.error "OAuth Error: #{e.message}"
          redirect_to login_path, alert: "#{provider.titleize}からのログインに失敗しました"
        end
      end
    end
  end

  private

  def merge_existing_account_or_fail(provider, exception)
    # メール重複時: 既存アカウントにプロバイダー認証を統合する
    # create_from 内で sorcery_fetch_user_hash が呼ばれ @user_hash が設定されている
    # @user_hashにはGoogleから持ってきたデータが入っている
    email = @user_hash&.dig(:user_info, "email")
    uid = @user_hash&.dig(:uid)&.to_s

    if email.present? && uid.present?
      existing_user = User.find_by(email: email)
      # 同じemailの既存ユーザーが存在すれば
      if existing_user
        # データベースにuidを登録
        existing_user.add_provider_to_user(provider.to_s, uid)
        # 認証方式の変更でのセキュリティ対策として古いセッションIDを断ち切る
        reset_session
        # 新しい方式でログインする
        auto_login(existing_user)
        redirect_to root_path, notice: "#{provider.titleize}でログインしました！"
        # リターンしてメソッドそのものから抜ける
        return
      end
    end
    #  既存アカウントで同じユーザーがないなどなどにより統合、ログインできなかった場合はここまできて失敗時の処理をする
    logger.error "OAuth Error (RecordNotUnique): #{exception.message}"
    redirect_to root_path, alert: "#{provider.titleize}からのログインに失敗しました"
  end
end
