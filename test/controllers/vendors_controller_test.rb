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


  # GET show
  test "show should work" do
    sign_in :user, users(:one)

    get :show, id: vendors(:one)
    assert_template :show
    assert_response :success
    assert_not_nil assigns(:trans)
    assert_equal assigns(:total), vendors(:one).checks.sum(:amount)
  end

  test "show should not work if the user is not logged in" do
    get :show, id: vendors(:one)
    assert_redirected_to new_user_session_path
  end

  test "show should not work if the if the vendor does not belong to the user" do
    sign_in :user, users(:user_without_properties)
    get :show, id: vendors(:one)
    assert_redirected_to root_path
  end


  # GET edit
  test "get edit" do
    sign_in :user, users(:one)

    get :edit, id: vendors(:one)
    assert_response :success
    assert_template :edit
  end

  test "get edit should not work if the user is not logged in" do
    get :edit, id: vendors(:one)
    assert_redirected_to new_user_session_path
  end

  test "get edit should not work if the vendor does not belong to the user" do
    sign_in :user, users(:user_without_properties)
    get :edit, id: vendors(:one)
    assert_redirected_to root_path
  end


  # PUT update
  test "put update" do
    sign_in :user, users(:one)

    put :update, id: vendors(:one), vendor: {
      name: "A new name"
    }

    assert_equal assigns(:vendor).name, "A new name"
  end

  test "put update should not work if the user is not logged in" do
    put :update, id: vendors(:one), vendor: {}
    assert_redirected_to new_user_session_path
  end

  test "put update should not work if the vendor does not belong to the user" do
    sign_in :user, users(:user_without_properties)
    put :update, id: vendors(:one), vendor: {}
    assert_redirected_to root_path
  end
end
