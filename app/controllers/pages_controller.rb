class PagesController < ApplicationController
  skip_before_action :require_login, only: %i[landing_page about term privacy]
  before_action :redirect_if_logged_in, only: %i[ landing_page about term privacy]
  def landing_page
  end

  def about
  end

  def term
  end

  def privacy
  end

  private

  def redirect_if_logged_in
    redirect_to dash_boards_path if logged_in?
  end
end
