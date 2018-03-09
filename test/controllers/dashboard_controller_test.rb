require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  test "should get services_panel" do
    get :services_panel
    assert_response :success
  end

end
