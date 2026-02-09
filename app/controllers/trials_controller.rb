class TrialsController < ApplicationController
  skip_before_action :require_login, only: %i[new create show]
  before_action :redirect_if_logged_in, only: %i[ new create show]


  def new
  end

  def create
  end

  def show
  end

  private

  def redirect_if_logged_in
    redirect_to dash_boards_path if logged_in?
  end
end
