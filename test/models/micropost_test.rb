require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:daniel)
    # @micropost = microposts(:orange)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  # test "pry" do
  #   binding.pry
  # end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do 
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be between 2 and 140 characters" do
    @micropost.content = "!"
    assert_not @micropost.valid?
    @micropost.content = "!"*141
    assert_not @micropost.valid?
  end

  test "should be ordered by newest to oldest post" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
