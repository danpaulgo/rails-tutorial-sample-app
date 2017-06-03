require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:daniel)
    @user_two = users(:michelle)
    @user_three = users(:user_3)
    @micropost = @user.microposts.create(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @user.valid?
  end

  # USER NAME TESTS

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end

  # USER EMAIL TESTS

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a"*244 + "@example.com"
    assert_not @user.valid?
  end

  test "valid email should be accepted" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |va|
      @user.email = va
      assert @user.valid?, "#{va.inspect} should be valid"
    end
  end

  test "invalid email should be rejected" do
    invalid_addresses = %w[user@example,com user_at_foo.org
   user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |ia|
      @user.email = ia
      assert_not @user.valid?, "#{ia.inspect} should be invalid"
    end
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be saved as lowercase" do
    email = @user.email.upcase!
    @user.save
    @user.reload.email
    assert_equal email.downcase, @user.email
  end

  # USER PASSWORD TESTS

  test "password should not be blank" do
    @user.password = @user.password_confirmation = " "*6
    assert_not @user.valid?
  end

  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end

  # USER MICROPOST TESTS

  test "associated microposts should be destroyed" do
    n = @user.microposts.count
    assert_difference 'Micropost.count', -n do
      @user.destroy
    end
  end

  # MISC

  test "authenticated? should return false when given nil digest" do
    assert_not @user.authenticated?(:remember, "test")
  end

  test "should be able to follow and unfollow other users" do
    assert @user.following?(@user_two)
    @user.unfollow(@user_two)
    assert_not @user.reload.following?(@user_two)
    assert_not @user_two.reload.followers.include?(@user)
    @user.follow(@user_two)
    assert @user.reload.following?(@user_two)
    assert@user_two.reload.followers.include?(@user)
  end

  test "feed should have right posts" do
    @user_two.microposts.each do |mp|
      assert @user.feed.include?(mp)
    end
    @user.microposts.each do |mp|
      assert @user.feed.include?(mp)
    end
    @user_three.microposts.each do |mp|
      assert_not @user.feed.include?(mp)
    end
  end

end
