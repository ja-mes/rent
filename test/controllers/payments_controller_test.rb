require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test "index should redirect to customer" do
    sign_in users(:one), scope: :user
    get :index, params: { customer_id: customers(:one) }
    assert_redirected_to customers(:one)
  end

  test "get new" do
    sign_in users(:one), scope: :user
    get :new, params: { customer_id: customers(:one) }
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:customer)
    assert_not_nil assigns(:payment)
    assert assigns(:payment).new_record?
  end

  test "should only allow new if customer belongs to user" do
    sign_in users(:user_without_properties), scope: :user
    get :new, params: { customer_id: customers(:one) }
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "new should redirect to sign in if no current user" do
    get :new, params: { customer_id: customers(:one) }
    assert_redirected_to new_user_session_path
  end



  test "create should create payment" do
    sign_in users(:one), scope: :user

    assert_difference ['Payment.count', 'Tran.count'], 1 do
      post :create, params: { customer_id: customers(:one), payment: { 
        customer_id: customers(:one).id,
        method: "Money Order",
        amount: "300",
        date: "03/11/2016",
        memo: "hello world",
        num: "foo"
      }}
    end

    assert_equal assigns(:payment).num, "foo"
    assert_equal assigns(:payment).account, accounts(:five)
    assert_equal assigns(:payment).method, "Money Order"
    assert_equal assigns(:payment).customer.balance, -300.00
    assert_redirected_to edit_customer_payment_path(assigns(:payment).customer, assigns(:payment))
    assert_not_nil assigns(:payment)
    assert_equal "Payment successfully created", flash[:success]
  end

  test "create should fail if form is filled out incorrectly" do
    sign_in users(:one), scope: :user

    assert_difference 'Payment.count', 0 do
      post :create, params: { customer_id: customers(:one), payment: { 
        amount: nil,
        date: nil,
        memo: " ",
      }}
    end

    assert_template :new
    assert_select '.form-errors'
  end

  test "create should only work if customer belongs to user" do
    sign_in users(:user_without_properties), scope: :user
    post :create, params: { customer_id: customers(:one) }
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "create should only work if user is signed in" do
    post :create, params: { customer_id: customers(:one) }
    assert_redirected_to new_user_session_path
  end

  test "get edit" do
    sign_in users(:one), scope: :user
    get :edit, params: { customer_id: customers(:one), id: payments(:one) }
    assert_response :success
    assert_template :edit
    assert_not_nil assigns(:payment)
    assert_equal assigns(:payment), payments(:one)
  end

  test "edit should only work if user is logged in" do
    get :edit, params: { customer_id: customers(:one), id: payments(:one) }
    assert_redirected_to new_user_session_path
  end

  test "edit should only work if customer belongs to user" do
    sign_in users(:user_without_properties), scope: :user
    get :edit, params: { customer_id: customers(:one), id: payments(:one) }
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end



  test "update should successfully update payment" do
    sign_in users(:one), scope: :user
    put :update, params: { customer_id: customers(:one), id: payments(:one), payment: { 
      amount: "200",
      method: "Cash",
      date: "05/08/2016",
      memo: "blah memo",
      num: "5"
    }}

    assert_equal assigns(:payment).num, "5"
    assert_equal assigns(:payment).amount, 200
    assert_equal assigns(:payment).method, "Cash"
    assert_equal assigns(:payment).date, Date.strptime("05/08/2016", "%d/%m/%Y")
    assert_equal assigns(:payment).memo, "blah memo"

    assert_redirected_to edit_customer_payment_path
  end

  test "update should not work if the payment has been deposited" do
    sign_in users(:one), scope: :user

    payments(:one).update_attribute :deposit, deposits(:one)

    put :update, params: { customer_id: customers(:one), id: payments(:one), payment: { 
      amount: "500",
      date: "06/02/2016",
      memo: "foobar",
    }}

    assert_not_equal assigns(:payment).amount, 500
    assert_not_equal assigns(:payment).date, "06/02/2016".to_date
    assert_not_equal assigns(:payment).memo, "foobar"
    assert_template :edit
  end

  test "update should not save with invalid data" do
    sign_in users(:one), scope: :user

    put :update, params: { customer_id: customers(:one), id: payments(:one), payment: { 
      amount: "",
      date: "",
      memo: "",
    }}

    assert_template :edit
    assert_select '.form-errors'
  end

  test "update should not work if user is not logged in" do
    put :update, params: { customer_id: customers(:one), id: payments(:one) }
    assert_redirected_to new_user_session_path
  end

  test "update should not work if customer does not belong to user" do
    sign_in users(:user_without_properties), scope: :user

    put :update, params: { customer_id: customers(:one), id: payments(:one) }
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "show should redirect to customer" do
    sign_in users(:one), scope: :user
    get :show, params: { customer_id: customers(:one), id: payments(:one) }
  end

  test "destroy should successfully destroy invoice" do
    sign_in users(:one), scope: :user

    assert_difference ['Payment.count', 'Tran.count'], -1 do
      delete :destroy, params: { customer_id: customers(:one), id: payments(:one) }
    end

    assert_not_nil assigns(:payment)
    assert_redirected_to customers(:one)
  end

  test "destroy should not work if the payment has been deposited" do
    sign_in users(:one), scope: :user

    payments(:one).update_attribute :deposit, deposits(:one)

    assert_difference ['Payment.count', 'Tran.count'], 0 do
      delete :destroy, params: { customer_id: customers(:one), id: payments(:one) }
    end

    assert_not_nil flash[:danger]
  end

  test "destroy should not work if the user is not logged in" do
    assert_difference 'Payment.count', 0 do
      delete :destroy, params: { customer_id: customers(:one), id: payments(:one) }
    end

    assert_redirected_to new_user_session_path
  end

  test "destroy should only work if the customer belongs to the user" do
    sign_in users(:user_without_properties), scope: :user

    assert_difference 'Payment.count', 0 do
      delete :destroy, params: { customer_id: customers(:one), id: payments(:one) }
    end

    assert_redirected_to root_path
  end

  test "destroy should only work if the invoice belongs to the user" do
    sign_in users(:one), scope: :user

    assert_difference 'Payment.count', 0 do
      delete :destroy, params: { customer_id: customers(:one), id: payments(:two) }
    end

    assert_redirected_to root_path
  end

  test "receipt should work" do
    sign_in users(:one), scope: :user

    get :receipt, params: { customer_id: customers(:one), id: payments(:one) }

    assert_response :success
    assert_not_nil assigns(:payment)
  end
end
