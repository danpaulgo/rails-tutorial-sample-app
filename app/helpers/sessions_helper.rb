module SessionsHelper

  def login(user)
    session[:user_id] = user.id
  end

  def logout
    session.clear # OR session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

end
