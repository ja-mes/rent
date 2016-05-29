require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "get index" do
    sign_in :user, users(:one)
    get :index
    assert_response :success
  end

  test "get index should not work if the user is not logged in" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "charge rent should work" do
    sign_in :user, users(:one)
    xhr :get, :index
    assert_response :success
  end

  test "charge rent should not work if the user is not logged in" do
    xhr :get, :index
    assert_response :unauthorized
  end
end
