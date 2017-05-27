require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
 
  include ApplicationHelper

  def setup
    @user = users(:daniel)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.order(:created_at)[0..9].each do |mp|
      assert_match mp.content, response.body
    end
  end

end