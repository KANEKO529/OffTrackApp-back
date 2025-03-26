class Api::V1::UsersController < ApplicationController
  def index
    users = User.order(created_at: :desc) # ✅ `created_at` の降順に並べる
    render json: users
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
  
    render json: { message: 'ユーザーデータが削除されました' }, status: :ok
    # head :ok
  end

  def update
    user = User.find(params[:id])

    if user.update(user_params)
      render json: { message: "ユーザーデータが正常に更新されました", user: user }, status: :ok
    else
      render json: { message: "ユーザーデータの更新に失敗しました", errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :nickname)
  end
end

