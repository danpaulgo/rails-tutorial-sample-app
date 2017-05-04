require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:daniel)
  end

  test "flash message disappears on second page" do
    User.create(email: "user@example.com", password: "password")
    get login_path
    post login_path, params: {session:{email: "user@example.com", password: "wrong_password"}}
    assert_select 'div.alert'
    assert_not flash.empty?
    get root_path
    assert_select 'div.alert', false
    assert flash.empty?
  end

  test "Valid login followed by logout" do
    get login_path
    post login_path, params: {session:{email: "danpaulgo@aol.com", password: "BayShore61893"}}
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    delete logout_path # Tests that hitting the delete button after user is logged out does not raise error AND redirects to home properly
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "Login with remember" do
      login_as(@user)
      assert_not_nil cookies['remember_token']
  end

  test "Login without remember" do
     login_as(@user, remember_me: 0)
     assert_nil cookies['remember_token']
  end

end
