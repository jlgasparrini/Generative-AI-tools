class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:create]

  # POST /api/v1/users
  def create
    user = User.new(user_params)

    if user.save
      render json: {
        user: user_response(user),
        token: user.api_token
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def user_response(user)
    {
      id: user.id,
      email: user.email,
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end
