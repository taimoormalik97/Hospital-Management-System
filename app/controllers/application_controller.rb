class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    respond_to do |format|
      format.html { render plain: '404 Not Found', status: 404 }
    end
  end
end
