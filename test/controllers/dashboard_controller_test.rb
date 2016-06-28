require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test "get index" do
    sign_in users(:one), scope: :user
    get :index
    assert_response :success
  end

  test "get index should not work if the user is not logged in" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "charge rent should work" do
    sign_in users(:one), scope: :user
    get :index, xhr: true
    assert_response :success
  end

  test "charge rent should not work if the user is not logged in" do
    get :index, xhr: true
    assert_response :unauthorized
  end
end
