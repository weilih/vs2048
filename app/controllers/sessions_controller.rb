class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: session_params[:username])
    if user && user.authenticate(session_params[:password])
      login user
      redirect_to matches_path
    else
      render :new
    end
  end

  def destroy
    logout(current_user) if current_user
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit(:username, :password)
  end
end
