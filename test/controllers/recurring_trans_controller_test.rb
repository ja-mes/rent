require 'test_helper'

class RecurringTransControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "get index" do
    sign_in :user, users(:one)
    get :index
    assert_response :success
  end

  test "post index should not work if the user is not logged in" do
    get :index
    assert_redirected_to new_user_session_path
  end
  
  test "post create should work for checks" do
    sign_in :user, users(:one)

    assert_difference "RecurringTran.count" do
      xhr :post, :create, id: checks(:one).id, type: "Check", due_date: "5"
    end
  end

  test "post create should not work if the user is not logged in" do
    assert_difference "RecurringTran.count", 0 do
      xhr :post, :create, id: checks(:one).id, type: "Check", due_date: "5"
    end

    assert_response :unauthorized
  end

  test "get edit" do
    sign_in :user, users(:one)
    xhr :get, :edit, id: recurring_trans(:one)
    assert_response :success
    assert_not_nil assigns(:tran)
  end

  test "get edit requires logged in user" do
    xhr :get, :edit, id: recurring_trans(:one)
    assert_response :unauthorized
  end

  test "get edit should not work if the tran does not belong to the user" do
    sign_in :user, users(:user_without_properties)
    xhr :get, :edit, id: recurring_trans(:one)
    assert_redirected_to root_path
  end

  test "put update" do
    sign_in :user, users(:one)

    xhr :put, :update, id: recurring_trans(:one), recurring_tran: {
      due_date: "3",
    }

    assert_equal assigns(:tran).due_date, "3"
  end

  test "put update requires logged in user" do
    xhr :put, :update, id: recurring_trans(:one), recurring_tran: {
      due_date: "3",
    }

    assert_response :unauthorized
  end

  test "put update requires tran to belong to user" do
    sign_in :user, users(:user_without_properties)

    put :update, id: recurring_trans(:one), recurring_tran: {
      due_date: "3",
    }

    assert_redirected_to root_path
  end

  test "delete destroy" do
    sign_in :user, users(:one)

    assert_difference 'RecurringTran.count', -1 do
      xhr :delete, :destroy, id: recurring_trans(:one)
    end

    assert_not_nil assigns(:tran)
  end

  test "delete destroy requires logged in user" do
    assert_difference 'RecurringTran.count', 0 do
      xhr :delete, :destroy, id: recurring_trans(:one)
    end

    assert_response :unauthorized
  end

  test "delete destroy requires same tran user" do
    sign_in :user, users(:user_without_properties)

    assert_difference 'RecurringTran.count', 0 do
      delete :destroy, id: recurring_trans(:one)
    end

    assert_redirected_to root_path
  end
end
