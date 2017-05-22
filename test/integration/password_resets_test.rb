require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:daniel)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Invalid Email
    post password_resets_path, params:{password_reset:{email: "invalid@email.com"}}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid Email
    post password_resets_path, params:{password_reset:{email: "danpaulgo@aol.com"}}
    @user.reload
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    @user = assigns(:user)
    # We use assigns instead of reload since we need to retrieve the reset_token which is saved to the object, but not inside the database
    # Expired token
    @user.update_attribute(:reset_sent_at, (Time.now - 3.hours))
    @user.reload
    get edit_password_reset_path(@user.reset_token, email: "danpaulgo@aol.com")
    assert_redirected_to new_password_reset_path
    follow_redirect!
    assert_template "password_resets/new"
    assert_not flash.empty?
    @user.reset_sent_at = Time.now
    # Wrong Email
    get edit_password_reset_path(@user.reset_token, email: "")
    assert_redirected_to root_url
    assert_not flash.empty?
    # Inactive User
    @user.toggle!(:activated) # Switches user from active to inactive
    get edit_password_reset_path(@user.reset_token, email: @user.email)
    assert_redirected_to root_url
    assert_not flash.empty?
    @user.toggle!(:activated)
    # Wrong Token
    get edit_password_reset_path("0123456789", email: @user.email)
    assert_redirected_to root_url
    assert_not flash.empty?
    # Right Email and Token
    get edit_password_reset_path(@user.reset_token, email: @user.email)
    assert_template 'password_resets/edit'
    # Verifies that form includes hidden input with user email to be passed along to the update action upon submission
    assert_select "input[name=email][type=hidden][value=?]", @user.email
    # Password and confirmation don't match
    patch password_reset_path(@user.reset_token), params:{email: @user.email, user:{password:"password1", password_confirmation: "password2"}}
    assert_select 'div#error_explanation'
    assert_template 'password_resets/edit'
    # Empty password
    patch password_reset_path(@user.reset_token), params:{email: @user.email, user:{password:"", password_confirmation: ""}}
    assert_select 'div#error_explanation'
    assert_template 'password_resets/edit'
    # Valid password
    patch password_reset_path(@user.reset_token), params:{email: @user.email, user:{password:"foobar", password_confirmation: "foobar"}}
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to @user
  end

end
