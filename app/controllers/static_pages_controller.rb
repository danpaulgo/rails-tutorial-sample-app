class StaticPagesController < ApplicationController
  def home
    # erb :'static_pages/home' is implemented automatically
    @micropost = current_user.microposts.build if logged_in?
    @feed_items = feed_items if logged_in?
  end

  def help

  end

  def about
  
  end

  def contact

  end
end
