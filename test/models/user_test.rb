require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name:"Example User", email: "user@example.com", password:"bayshore618", password_confirmation:"bayshore618")
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

  test "email should not be blank" do
    @user.password = @user.password_confirmation = " "*6
    assert_not @user.valid?
  end

  test "email should have minimum length" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end

  # MISC

  test "authenticated? should return false when given nil digest" do
    assert_not @user.authenticated?("test")
  end

end
