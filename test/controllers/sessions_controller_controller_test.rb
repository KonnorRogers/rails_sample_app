require 'test_helper'

class SessionsControllerControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sessions_controller_new_url
    assert_response :success
  end

end
