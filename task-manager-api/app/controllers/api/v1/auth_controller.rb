class Api::V1::AuthController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:login]

  # POST /api/v1/auth/login
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      render json: {
        user: user_response(user),
        token: user.api_token
      }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def user_response(user)
    {
      id: user.id,
      email: user.email,
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end
