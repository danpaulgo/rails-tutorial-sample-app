require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:daniel)
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path params:{micropost:{content: "Lorem ipsum"}}
    end
    assert_redirected_to login_path
  end

  test "should redirect update when not logged in" do
    patch micropost_path(@micropost), params:{micropost:{content: "Edited"}}
    assert_equal @micropost.content, @micropost.reload.content
    assert_redirected_to login_path
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy for wrong micropost" do
    login_as(@user)
    micropost = microposts(:michelle_one)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
  end

end
