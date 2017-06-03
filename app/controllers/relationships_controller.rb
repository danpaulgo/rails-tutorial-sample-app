class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:destroy]

  def create
    @followed_user = User.find_by(id: params[:followed_id])
    if current_user.following?(@followed_user)
      flash[:error] = "You are already following this user"
    else
      current_user.follow(@followed_user)
      flash[:success] = "You are now following #{@followed_user.name}"
    end
    redirect_to @followed_user
  end

  def destroy
    relationship = Relationship.find(params[:id])
    @followed_user = relationship.followed
    if relationship.follower == current_user
      relationship.delete 
      flash[:success] = "You are no longer following #{@followed_user.name}"
    else
      flash[:warning] = "Unauthorized action"
    end
    redirect_to @followed_user
  end

  private

    def correct_user

    end
end
