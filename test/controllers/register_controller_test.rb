require 'test_helper'

class RegisterControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  # GET index
  test "get index" do
    sign_in :user, users(:one)

    get :index
    assert_not_nil assigns(:trans)
    assert_not_nil assigns(:balance)
  end

  test "get index should not work if the user is not logged in" do
    get :index
    assert_redirected_to new_user_session_path
  end
end
