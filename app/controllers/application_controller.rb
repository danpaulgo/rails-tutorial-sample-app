class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  def feed_items
    current_user.feed.paginate(page: params[:page], per_page: 15)
  end

  private

    # BEFORE FILTERS

    # Confirms logged-in user
    def logged_in_user
      if !logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_path
      end
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end



end
