class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Adds user to session  AND cookie upon login
      login(user, params[:session][:remember_me])
      redirect_to user
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_path
  end
end
