class ErrorsController < ApplicationController
  def not_found
    render status: :not_found, layout: "errors"
  end

  def internal_server_error
    render status: :internal_server_error, layout: "errors"
  end

  def unprocessable_entity
    render status: :unprocessable_entity, layout: "errors"
  end
end
