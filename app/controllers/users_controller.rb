class UsersController < ApplicationController
  def index
    @users = User.exclude(current_user).order(:status, :username)
  end

  def new
    @user = User.new
  end

  def create
    if @user = User.create(user_params)
      login @user
      redirect_to matches_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
