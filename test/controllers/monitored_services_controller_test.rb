require 'test_helper'

class MonitoredServicesControllerTest < ActionController::TestCase
  setup do
    @monitored_service = monitored_services(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:monitored_services)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create monitored_service" do
    assert_difference('MonitoredService.count') do
      post :create, monitored_service: { description: @monitored_service.description, host: @monitored_service.host, port: @monitored_service.port, service_type: @monitored_service.service_type }
    end

    assert_redirected_to monitored_service_path(assigns(:monitored_service))
  end

  test "should show monitored_service" do
    get :show, id: @monitored_service
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @monitored_service
    assert_response :success
  end

  test "should update monitored_service" do
    patch :update, id: @monitored_service, monitored_service: { description: @monitored_service.description, host: @monitored_service.host, port: @monitored_service.port, service_type: @monitored_service.service_type }
    assert_redirected_to monitored_service_path(assigns(:monitored_service))
  end

  test "should destroy monitored_service" do
    assert_difference('MonitoredService.count', -1) do
      delete :destroy, id: @monitored_service
    end

    assert_redirected_to monitored_services_path
  end
end
