require 'test_helper'

class RecurringTransControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test "get index" do
    sign_in users(:one), scope: :user
    get :index
    assert_response :success
  end

  test "post index should not work if the user is not logged in" do
    get :index
    assert_redirected_to new_user_session_path
  end
  
  test "post create should work for checks" do
    sign_in users(:one), scope: :user

    assert_difference "RecurringTran.count" do
      post :create, xhr: true, id: checks(:one).id, type: "Check", due_date: "5"
    end
  end

  test "post create should not work if the user is not logged in" do
    assert_difference "RecurringTran.count", 0 do
      post :create, xhr: true, id: checks(:one).id, type: "Check", due_date: "5"
    end

    assert_response :unauthorized
  end

  test "get edit" do
    sign_in users(:one), scope: :user
    get :edit, xhr: true, id: recurring_trans(:one)
    assert_response :success
    assert_not_nil assigns(:tran)
  end

  test "get edit requires logged in user" do
    get :edit, xhr: true, id: recurring_trans(:one)
    assert_response :unauthorized
  end

  test "get edit should not work if the tran does not belong to the user" do
    sign_in users(:user_without_properties), scope: :user
    get :edit, xhr: true, id: recurring_trans(:one)
    assert_redirected_to root_path
  end

  test "put update" do
    sign_in users(:one), scope: :user

    put :update, xhr: true, id: recurring_trans(:one), recurring_tran: {
      due_date: "3",
    }

    assert_equal assigns(:tran).due_date, "3"
  end

  test "put update requires logged in user" do
    put :update, xhr: true, id: recurring_trans(:one), recurring_tran: {
      due_date: "3",
    }

    assert_response :unauthorized
  end

  test "put update requires tran to belong to user" do
    sign_in users(:user_without_properties), scope: :user

    put :update, id: recurring_trans(:one), recurring_tran: {
      due_date: "3",
    }

    assert_redirected_to root_path
  end

  test "delete destroy" do
    sign_in users(:one), scope: :user

    assert_difference 'RecurringTran.count', -1 do
      delete :destroy, xhr: true, id: recurring_trans(:one)
    end

    assert_not_nil assigns(:tran)
  end

  test "delete destroy requires logged in user" do
    assert_difference 'RecurringTran.count', 0 do
      delete :destroy, xhr: true, id: recurring_trans(:one)
    end

    assert_response :unauthorized
  end

  test "delete destroy requires same tran user" do
    sign_in users(:user_without_properties), scope: :user

    assert_difference 'RecurringTran.count', 0 do
      delete :destroy, id: recurring_trans(:one)
    end

    assert_redirected_to root_path
  end
end
