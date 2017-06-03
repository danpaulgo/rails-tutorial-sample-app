require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
 
  def setup
    @relationship = relationships(:one)
  end

  test "create should require logged in user" do 
    assert_no_difference "Relationship.count" do
      post relationships_path
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged in user" do
    assert_no_difference "Relationship.count" do
      delete relationship_path(@relationship)
    end
    assert_redirected_to login_url
  end 

end
