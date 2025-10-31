module Api
  module V1
    class BaseController < ActionController::API
      include Authenticable
      
      # This will be the parent controller for all API v1 controllers
      # Common functionality and concerns will be included here
    end
  end
end
