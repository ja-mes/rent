require 'test_helper'

class RegistersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test "get index" do
    sign_in users(:one), scope: :user

    get :index
    assert_response :success
  end

  test "get index should require logged in user" do
    get :index
    assert_redirected_to new_user_session_path
  end
end
