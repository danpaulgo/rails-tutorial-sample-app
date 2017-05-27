class MicropostsController < ApplicationController

  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = feed_items
      render 'static_pages/home'
    end
  end

  def edit
    @micropost = Micropost.find(params[:id])
  end

  def update

  end

  def destroy
    @micropost = Micropost.find(params[:id])
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      redirect_to root_path unless current_user?(Micropost.find(params[:id]).user)
    end

end
