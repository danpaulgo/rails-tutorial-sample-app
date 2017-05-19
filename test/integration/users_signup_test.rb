require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup submission" do
    assert_no_difference 'User.count' do
      post signup_path, params:{user:{name: "", email: "user@invaldid", password: "foo", password_confirmation: "bar"}}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
  end

  test "valid signup submission with account activation" do
    assert_difference 'User.count', 1 do
      post signup_path, params:{user:{name: "Example User", email: "user@example.com", password: "password", password_confirmation: "password"}}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    # user = User.last
    assert_not user.activated?
    login_as user
    assert_not is_logged_in?
    assert_not flash.empty?
    get edit_account_activation_path(user.activation_token, email: 'invalid')
    assert_not is_logged_in?
    assert_not user.reload.activated?
    get edit_account_activation_path(user.activation_token, email: user.email)
    follow_redirect!
    user.reload
    assert user.activated?
    assert is_logged_in?
    assert_template 'users/show'
    # assert_template 'users/show'
    # assert_select 'div.alert'
    # assert_not flash.empty?
    # assert is_logged_in?
  end

end
