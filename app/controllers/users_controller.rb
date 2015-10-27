class UsersController < ApplicationController
  def index
    @users = User.all.select(:username, :status)
  end

  def new
    @user = User.new
  end

  def create
    if @user = User.create(user_params)
      login @user
      redirect_to users_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
