require 'test_helper'

class PropertiesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test "get index" do
    sign_in users(:one), scope: :user
    get :index
    assert_template :index
    assert_response :success
    assert_not_nil assigns(:properties)
  end

  test "index redirect to signin and display error if not logged in" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "test new" do
    sign_in users(:one), scope: :user
    get :new
    assert_template :new
    assert_response :success
    assert_not_nil assigns(:property)
  end

  test "new should redirect to signin if no current user" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "create should successfully create property" do
    sign_in users(:one), scope: :user

    assert_difference 'Property.count', 1 do
      post :create, params: { property: {
        address: "Foo1",
        city: "Blah",
        state: "AL",
        zip: "23423",
        deposit: 300,
        rent: 500,
      }}
    end

    assert_redirected_to property_path assigns(:property)
    assert_equal 'Property successfully saved', flash[:success]
  end

  test "create should not save property if form is filled out incorrectly" do
    sign_in users(:one), scope: :user

    assert_difference 'Property.count', 0 do
      post :create, params: { property: {
        address: "",
        city: "",
        state: "",
        zip: "",
        deposit: nil,
        rent: nil,
      }}
    end

    assert_template :new
    assert_select '.form-errors'
  end

  test "create should redirect to signin if no current user" do
    post :create
    assert_redirected_to new_user_session_path
  end

  test "show should show properties details page" do
    sign_in users(:one), scope: :user

    get :show, params: { id: properties(:one) }
    assert_response :success
    assert_template :show
    assert_not_nil assigns(:property)
  end

  test "should only show property if it belongs to current user" do
    sign_in users(:two), scope: :user

    get :show, params: { id: properties(:one) }
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "show should redirect to signin if no current user" do
    get :show, params: { id: properties(:one) }
    assert_redirected_to new_user_session_path
  end

  test "get edit" do
    sign_in users(:one), scope: :user

    get :edit, params: { id: properties(:one) }
    assert_response :success
    assert_template :edit
    assert_not_nil assigns(:property)
  end

  test "should only allow editing if property belongs to current user" do
    sign_in users(:two), scope: :user

    get :edit, params: { id: properties(:one) }
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "edit should redirect to signin if no current user" do
    get :edit, params: { id: properties(:one) }
    assert_redirected_to new_user_session_path
  end

  test "should be able to update property" do
    sign_in users(:one), scope: :user

    put :update, params: { id: properties(:one), property: {
      address: "NewAddress",
      city: "NewCity",
      state: "CA",
      zip: "511",
      deposit: 100,
      rent: 200
    }}

    assert_equal "NewAddress", assigns(:property).address
    assert_equal "NewCity", assigns(:property).city
    assert_equal "CA", assigns(:property).state
    assert_equal "511", assigns(:property).zip
    assert_equal 100, assigns(:property).deposit
    assert_equal 200, assigns(:property).rent

    assert_equal 'Property successfully updated', flash[:success]
  end

  test "should not be able to update property if form is filled out incorrectly" do
    sign_in users(:one), scope: :user

    put :update, params: { id: properties(:one), property: {
      address: "",
      city: "",
      state: "",
      zip: "",
      deposit: nil,
      rent: nil
    }}

    assert_template :edit
    assert_select '.form-errors' # error messages should appear
  end

  test "should only allow updating property if it belongs to current user" do
    sign_in users(:two), scope: :user

    get :update, params: { id: properties(:one) }
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "should not be able to update property if not logged in" do
    put :update, params: { id: properties(:one) }
    assert_redirected_to new_user_session_path
  end

end
