class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |exception|
    message = {
      "message": "#{exception.message}",
      "data": {}
    }
    json_response(message, :not_found)
  end
end
