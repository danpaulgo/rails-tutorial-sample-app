module SessionsHelper

  # Remembers a user in a persistent session.
  def remember_user_in_cookie(user)
    user.remember_token_digest
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def login(user, remember_me = 0)
    session[:user_id] = user.id
    @current_user = user
    remember_me == '1' ? remember_user_in_cookie(user) : forget_user_from_cookie(user)
  end

  # Deletes digest from database AND clears user_id and remember_token from cookie
  def forget_user_from_cookie(user)
    user.forget_digest
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Deletes user_id from session, user_id from cookie, remember_token from cookie, and remember_digest from datatbase
  def logout
    forget_user_from_cookie(current_user)
    session.clear
    @current_user = nil
  end

  # If the session hash has a user_id, the current user will be based on that. If the cookie hash holds a user_id, the curent user will be based on that. Otherwise, no current_user will be returned
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      # If a user is found AND the cookies remember_token (if exists) matches the unhashed remember_digest of "user", then the current_user will be set
      if user && user.authenticated?(cookies[:remember_token])
        session[:user_id] = user.id
        @current_user ||= user
      end
    end
  end

  def logged_in?
    !!current_user
  end

end
