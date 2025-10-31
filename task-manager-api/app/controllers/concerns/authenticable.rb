module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  private

  def authenticate_user!
    token = extract_token_from_header
    
    if token.blank?
      render_unauthorized("Missing authentication token")
      return
    end

    @current_user = User.find_by(api_token: token)

    if @current_user.nil?
      render_unauthorized("Invalid authentication token")
    end
  end

  def current_user
    @current_user
  end

  def extract_token_from_header
    # Extract token from Authorization header: "Bearer <token>"
    auth_header = request.headers['Authorization']
    return nil if auth_header.blank?

    # Split "Bearer token" and return the token part
    auth_header.split(' ').last if auth_header.start_with?('Bearer ')
  end

  def render_unauthorized(message = "Unauthorized")
    render json: { error: message }, status: :unauthorized
  end
end
