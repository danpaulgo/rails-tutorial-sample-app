require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:daniel)
    @user_two = users(:user_2)
  end

  test "micropost interface" do
    login_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params:{micropost:{content:""}}
    end
    # Valid submission
    content = "Valid micropost"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params:{micropost:{content: content, picture: picture}}
    end
    assert assigns(:micropost).picture?
    assert_redirected_to root_path
    follow_redirect!
    assert_match content, response.body
    # Edit Micropost

    #Delete post
    assert_select 'a', text: 'Delete'
    assert_select 'a', text: 'Edit'
    micropost = Micropost.first
    assert_equal "Valid micropost", micropost.content
    assert_equal @user, micropost.user
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(micropost)
    end 
    # Visit different user (no delete links)
    get user_path(@user_two)
    assert_select 'a', text: 'Delete', count: 0
    assert_select 'a', text: 'Edit', count: 0
  end

  test "micropost sidebar count" do
    login_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # User with no microposts
    login_as(@user_two, password: "password")
    assert_equal logged_in_user, @user_two
    get root_path
    assert_match "0 microposts", response.body
    @user_two.microposts.create!(content: "Post")
    get root_path
    assert_match "1 micropost", response.body
  end

end
