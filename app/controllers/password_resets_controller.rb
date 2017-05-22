class PasswordResetsController < ApplicationController
  
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] # Case (1)

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      UserMailer.password_reset(@user).deliver_now
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty? # Case (3)
      @user.errors.add(:password, "Password cannot be blank")
      render 'edit'
    elsif @user.update_attributes(user_params) # Case (4) (success)
      login @user
      flash[:success] = "Password has been reset"
      @user.update_attribute(:reset_digest, nil)
      redirect_to @user
    else
      render 'edit' # Case (2)
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
      # What happens if you require password and password_confirmation instead of permit?
    end

    def valid_user
      @user = User.find_by(email: params[:email])
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        flash[:danger] = "Invalid password reset link"
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset link has expired"
        redirect_to new_password_reset_path
      end
    end

end
