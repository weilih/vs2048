module SessionsHelper
  def login(user)
    session[:user_id] = user.id
    user.online!
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logout(user)
    session.delete(:user_id)
    user.offline!
  end
end
