class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :followers, :following]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]

  def index
    @users = User.where(activated: true).paginate(page: params[:page], per_page: 20).order("name ASC")
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], per_page: 10)
    if !@user.activated
      flash[:warning] = "User is not yet active"
      redirect_to root_path
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email for a link to activate your account"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find_by(id: params[:id]).destroy
    flash[:success] = "User successfully deleted"
    redirect_to users_path
    render 'follows'
  end

  def followers
    @title = "Followers"
    @user = User.find_by(id: params[:id])
    @items_per_page = 20
    @users = @user.followers.paginate(page: params[:page], per_page: @items_per_page) if @user
    render 'follows'
  end

  def following
    @title = "Following"
    @user = User.find_by(id: params[:id])
    @items_per_page = 20
    @users = @user.following.paginate(page: params[:page], per_page: @items_per_page) if @user
    render 'follows'
  end

  private

    def correct_user
      redirect_to root_path unless current_user?(User.find(params[:id]))
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
