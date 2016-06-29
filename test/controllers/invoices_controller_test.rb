require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test "index should redirect to customer" do
    sign_in users(:one), scope: :user
    get :index, customer_id: customers(:one)
    assert_redirected_to customers(:one)
  end

  test "get new" do
    sign_in users(:one), scope: :user
    get :new, customer_id: customers(:one)

    assert_response :success
    assert_template :new
    assert_not_nil assigns(:customer)
    assert_not_nil assigns(:invoice)
    assert assigns(:invoice).new_record?
    assert_not_nil assigns(:properties)
    assert_not_nil assigns(:accounts)
  end

  test "get new should not work if user is not logged in" do
    get :new, customer_id: customers(:one)
    assert_redirected_to new_user_session_path
  end

  test "new should not work if the customer does not belong to the user" do
    sign_in users(:user_without_properties), scope: :user
    get :new, customer_id: customers(:one)
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "create should create invoice, account_trans and transaction" do
    sign_in users(:one), scope: :user

    assert_difference ['Invoice.count', 'Tran.count', 'AccountTran.count'] do
      post :create, customer_id: customers(:one), invoice: {
        customer_id: customers(:three),
        amount: "500",
        date: "03/10/2016",
        memo: "this is the memo",
        account_trans_attributes: {
          "0" => {
            account_id: accounts(:one).id,
            amount: 500,
            memo: "foo bar",
            property_id: properties(:four).id
          }
        }
      }
    end

    assert_not_nil assigns(:invoice)
    assert_equal assigns(:invoice).customer.balance, 500.00

    # account trans should have date and user assigned
    assert_equal assigns(:invoice).account_trans.first.date, Date.strptime("03/10/2016", "%d/%m/%Y") 
    assert_equal assigns(:invoice).account_trans.first.user, users(:one)

    assert_redirected_to edit_customer_invoice_path(assigns(:invoice).customer, assigns(:invoice))
    assert_equal "Invoice successfully saved", flash[:success]
  end

  test "create should only work if the user is logged in" do
    post :create, customer_id: customers(:one)
    assert_redirected_to new_user_session_path
  end

  test "create should not work with invalid form data" do
    sign_in users(:one), scope: :user

    assert_difference 'Invoice.count', 0 do
      post :create, customer_id: customers(:one), invoice: {
        amount: nil,
        date: nil,
        memo: nil
      }
    end

    assert_template :new
    assert_select '.form-errors'
  end

  test "create should only work if customer belongs to user" do
    sign_in users(:user_without_properties), scope: :user
    post :create, customer_id: 1
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "get edit" do
    sign_in users(:one), scope: :user
    get :edit, customer_id: customers(:one), id: invoices(:one)
    assert_response :success
    assert_template :edit
    assert_not_nil assigns(:invoice)
    assert_equal assigns(:invoice), invoices(:one)
  end

  test "edit should only work if the user is logged in" do
    get :edit, customer_id: customers(:one), id: invoices(:one)
    assert_redirected_to new_user_session_path
  end

  test "edit should only work if the customer belongs to user" do
    sign_in users(:user_without_properties), scope: :user
    get :edit, customer_id: customers(:one), id: invoices(:one)
    assert_redirected_to root_path
  end

  test "edit should only work if invoice belongs to user" do
    sign_in users(:one), scope: :user
    get :edit, customer_id: customers(:one), id: invoices(:two)
    assert_redirected_to root_path
  end


  
  test "update should successfully update invoice" do
    sign_in users(:one), scope: :user

    put :update, customer_id: customers(:one), id: invoices(:one), invoice: {
      customer_id: customers(:three).id,
      amount: "700.22",
      date: "05/08/2016",
      memo: "blah memo",
      account_trans_attributes: {
        "0" => {
          account_id: accounts(:two).id,
          amount: 200,
          memo: "memo 1",
          property_id: properties(:four).id
        }
      }
    }

    assert_redirected_to edit_customer_invoice_path(assigns(:invoice).customer, assigns(:invoice))
    assert_equal assigns(:invoice).amount, 700.22
    assert_equal assigns(:invoice).date, Date.strptime("05/08/2016", "%d/%m/%Y")
    assert_equal assigns(:invoice).memo, "blah memo"
  end

  test "update should not work with invalid data" do
    sign_in users(:one), scope: :user

    put :update, customer_id: customers(:one), id: invoices(:one), invoice: {
      amount: "",
      date: "",
      memo: ""
    }

    assert_not_nil assigns(:invoice)
    assert_template :edit
    assert_select '.form-errors'
  end

  test "update should only work if the user is logged in" do
    put :update, customer_id: customers(:one), id: invoices(:one)
    assert_redirected_to new_user_session_path
  end

  test "update should only work if customer belongs to user" do
    sign_in users(:user_without_properties), scope: :user

    put :update, customer_id: customers(:one), id: invoices(:one)
    assert_redirected_to root_path
  end

  test "update should only work if invoice belongs to user" do
    sign_in users(:one), scope: :user
    get :edit, customer_id: customers(:one), id: invoices(:two)
    assert_redirected_to root_path
  end



  test "destroy should successfully destroy invoice" do
    sign_in users(:one), scope: :user

    assert_difference ['Invoice.count', 'Tran.count'], -1 do
      delete :destroy, customer_id: customers(:one), id: invoices(:one)
    end

    assert_not_nil assigns(:invoice)
    assert_redirected_to customers(:one)
  end

  test "destroy should not work if the user is not logged in" do
    assert_difference 'Invoice.count', 0 do
      delete :destroy, customer_id: customers(:one), id: invoices(:one)
    end

    assert_redirected_to new_user_session_path
  end

  test "destroy should only work if the customer belongs to the user" do
    sign_in users(:user_without_properties), scope: :user

    assert_difference 'Invoice.count', 0 do
      delete :destroy, customer_id: customers(:one), id: invoices(:one)
    end

    assert_redirected_to root_path
  end

  test "destroy should only work if the invoice belongs to the user" do
    sign_in users(:one), scope: :user

    assert_difference 'Invoice.count', 0 do
      delete :destroy, customer_id: customers(:one), id: invoices(:two)
    end

    assert_redirected_to root_path
  end

  test "show should redirect to edit" do
    sign_in users(:one), scope: :user
    get :show, customer_id: customers(:one), id: invoices(:one)

    assert_redirected_to edit_customer_invoice_path
  end
end
