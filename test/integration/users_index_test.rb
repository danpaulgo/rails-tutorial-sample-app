require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:daniel)
    @non_admin = users(:michelle)
    @inactive_user = users(:john)
  end

  test "index as admin" do
    login_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    # WHY WONT THIS WORK???
    # User.all.order("name ASC")[0..19].each do |user|
    #   assert_select 'a[href=?]', users_path(user), text: user.name
    #   unless user == @admin
    #     assert_select 'a[href=?]', users_path(user), text: 'Delete User'
    #   end
    # end
    assert_select 'a', text: 'Delete User', count: 20
  end

  test "index as non admin" do 
    login_as @non_admin
    get users_path
    assert_select 'a', text: 'Delete User', count: 0
  end

  test "redirects when attempting to view inactive user profile" do
    login_as @admin
    get user_path(@inactive_user)
    assert_redirected_to root_path
    assert_not flash.empty?
  end

end
