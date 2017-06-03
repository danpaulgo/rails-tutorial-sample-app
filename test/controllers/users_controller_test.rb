require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:daniel)
    @user_two = users(:michelle)
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_path
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect from edit page when logged out" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect from update action when logged out" do
    patch user_path(@user), params:{user:{name:@user.name, email: @user.email}}
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should rediect from edit when logged in as wrong user" do
    login_as(@user_two, password: 'password')
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should rediect update action when logged in as wrong user" do
    login_as(@user_two, password: 'password')
    patch user_path(@user), params:{user:{name: @user.name, email: @user.email}}
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should not allow admin attributes to be edited via web request" do
    login_as(@user_two, password: 'password')
    assert is_logged_in?
    assert_not @user_two.admin?
    patch user_path(@user_two), params:{user:{name: "Failed Admin"}}
    @user_two.reload
    assert_not @user_two.admin?
    assert_equal "Failed Admin", @user_two.name
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user_two)
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy when logged in as non-admin" do
    login_as(@user_two, password: "password")
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_path
  end

  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert assert_redirected_to login_path
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert assert_redirected_to login_path
  end
end
