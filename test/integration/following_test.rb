require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:daniel)
    @user_two = users(:user_3)
    login_as(@user)
  end

  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    # For each user that @user is following, assert that a link to their profile is present on the folowing page
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "follow and unfollow user" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params:{followed_id: @user_two.id}
    end
    assert_difference '@user.following.count', -1 do
      relationship = @user.active_relationships.find_by(followed_id: @user_two.id)
      delete relationship_path(relationship)
    end
  end

  # test "follow user with ajax" do
  #   assert_difference '@user.following.count', 1 do
  #     post relationships_path, params:{followed_id:{@other.id}, xhr: true}
  #   end
  # end
  # XHR: TRUE IS THE ONLY DIFFERENCE

  test "feed on Home page" do
    get root_path
    @user.feed.paginate(page:1, per_page: 15).each do |mp|
      assert_match CGI.escapeHTML(mp.content), response.body
      # CGI.escapeHTML is necessary since response.body comes in HTML form
    end
  end

end
