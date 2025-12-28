class PagesController < ApplicationController
  skip_before_action :require_login, only: %i[landing_page]
  before_action :redirect_if_logged_in, only: [ :landing_page ]
  def landing_page
  end

  private

  def redirect_if_logged_in
    redirect_to dash_boards_path if logged_in?
  end
end
