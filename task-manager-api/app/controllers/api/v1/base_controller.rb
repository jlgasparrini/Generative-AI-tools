module Api
  module V1
    class BaseController < ActionController::API
      include Authenticable
      
      # Global error handling
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      
      # This will be the parent controller for all API v1 controllers
      # Common functionality and concerns will be included here

      private

      def record_not_found
        render json: { error: "Not Found" }, status: :not_found
      end
    end
  end
end
