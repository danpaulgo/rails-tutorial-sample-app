require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup submission" do
    assert_no_difference 'User.count' do
      post signup_path, params:{user:{name: "", email: "user@invaldid", password: "foo", password_confirmation: "bar"}}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
  end

  test "valid signup submission" do
    assert_difference 'User.count' do
      post signup_path, params:{user:{name: "Example User", email: "user@example.com", password: "password", password_confirmation: "password"}}
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select 'div.alert'
    assert_not flash.empty?
    assert is_logged_in?
  end

end
