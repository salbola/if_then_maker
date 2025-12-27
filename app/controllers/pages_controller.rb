class PagesController < ApplicationController
  skip_before_action :require_login, only: %i[landing_page]
  def landing_page
  end
end
