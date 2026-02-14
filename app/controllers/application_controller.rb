class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :require_login
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def not_authenticated
    redirect_to login_path, alert: "ログインしてください"
  end
  def user_not_authorized
    redirect_to root_path, alert: "権限がありません"
  end


end
