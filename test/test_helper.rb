ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper
  # include SessionsHelper

  def is_logged_in?
    !session[:user_id].nil?
  end

  def logged_in_user
    User.find_by(id: session[:user_id])
  end

  def login_as(user)
    session[:user_id] = user.id
  end

end

class ActionDispatch::IntegrationTest

  def login_as(user, password: 'BayShore61893', remember_me: '1')
    post login_path, params:{session:{email: user.email, password: password, remember_me: remember_me}}
  end

end
