require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test "get index" do
    sign_in users(:one), scope: :user

    get :index
    assert_response :success
  end

  test "get index requires logged in user" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "post update_checkbook_balance" do
    sign_in users(:one), scope: :user
    checkbook = users(:one).checkbook
    checkbook.balance = 0
    checkbook.set_beginning_balance(500)

    assert_equal checkbook.reload.balance, 500
  end
end
