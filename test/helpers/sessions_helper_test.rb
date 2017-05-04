require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:daniel)
  end 

  
  test "current_user returns right user when session is nil" do
    remember_user_in_cookie(@user)
    assert_equal @user, current_user
    assert is_logged_in?
  end 

end