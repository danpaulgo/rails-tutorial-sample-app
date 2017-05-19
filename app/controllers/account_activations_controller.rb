class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    token = params[:id]
    if user && !user.activated && user.authenticated?(:activation, token)
      user.activate
      login user
      flash[:success] = "Account activated!"
      redirect_to user
    else 
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end

end
