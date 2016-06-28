require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test "get index" do
    sign_in users(:one), scope: :user

    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:accounts)
  end

  test "get index should not work if user is not logged in" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "get new" do
    sign_in users(:one), scope: :user

    get :new
    assert_response :success
    assert_not_nil assigns(:account)
  end

  test "get new should not work if the user is not logged in" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "post create" do
    sign_in users(:one), scope: :user

    assert_difference 'Account.count' do
      post :create, params: { account: {
        name: "Foo",
        account_type_id: account_types(:income)
      }}
    end

    assert_not_nil assigns(:account)
    assert_not_nil assigns(:account).user
  end

  test "post create shoud fail with invalid data" do
    sign_in users(:one), scope: :user

    assert_difference 'Account.count', 0 do
      post :create, params: { account: {
        name: "",
        account_type_id: ""
      }}
    end

    assert_template 'new'
  end

  test "post create should not work if user is not logged in" do
    post :create, params: { account: {} }

    assert_redirected_to new_user_session_path
  end

  test "get show" do
    sign_in users(:one), scope: :user

    get :show, params: { id: accounts(:one) }
    assert_response :success
    assert_template :show
    assert_not_nil assigns(:account)
    assert_equal assigns(:negate), !assigns(:account).account_type.inc
  end

  test "get show should not work if user is not logged in" do
    get :show, params: { id: accounts(:one) }
    assert_redirected_to new_user_session_path
  end

  test "get edit" do
    sign_in users(:one), scope: :user

    get :edit, params: { id: accounts(:one) }
    assert_response :success
    assert_template :edit
    assert_not_nil assigns(:account)
  end

  test "get edit should not work if the user is not signed in" do
    get :edit, params: { id: accounts(:one) }
    assert_redirected_to new_user_session_path
  end

  test "post update" do
    sign_in users(:one), scope: :user

    post :update, params: { id: accounts(:one), account: {
      name: "Bar"
    }}

    assert_equal assigns(:account).name, "Bar"
  end

  test "post update should not update type" do
    sign_in users(:one), scope: :user

    post :update, params: { id: accounts(:one), account: {
      name: "Bar",
      account_type_id: account_types(:expenses)
    }}

    assert_equal assigns(:account).account_type, account_types(:income)
  end

  test "post update should not work if invalid form data is submitted" do
    sign_in users(:one), scope: :user

    post :update, params: { id: accounts(:one), account: {
      name: ""
    }}

    assert_template :edit
  end

  test "post update should not work if user is not logged in" do
    post :update, params: { id: accounts(:one), account: {} }
    assert_redirected_to new_user_session_path
  end
end
