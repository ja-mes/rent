require 'test_helper'

class VendorsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # GET index
  test "get index" do
    sign_in :user, users(:one)

    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:vendors)
  end

  test "get index should not work if the user is not logged in" do
    get :index
    assert_redirected_to new_user_session_path
  end


  # GET new
  test "get new" do
    sign_in :user, users(:one)

    get :new
    assert_response :success
    assert_not_nil assigns(:vendor)
  end

  test "get new should only work if the user is logged in" do
    get :new
    assert_redirected_to new_user_session_path
  end


  # POST create
  test "post create should successfully create vendor" do
    sign_in :user, users(:one)

    assert_difference 'Vendor.count' do
      post :create, vendor: {
        name: "Foo Bar"
      }
    end

    assert_equal assigns(:vendor).name, "Foo Bar"
  end

  test "post create should not work if the user is not logged in" do
    post :create, vendor: {}
    assert_redirected_to new_user_session_path
  end
end
