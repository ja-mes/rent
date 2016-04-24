class InvoicesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "index should redirect to customer" do
    sign_in :user, users(:one)
    get :index, customer_id: customers(:one)
    assert_redirected_to customers(:one)
  end

  test "new action should work" do
    sign_in :user, users(:one)
    get :new, customer_id: customers(:one)

    assert_response :success
    assert_template :new
    assert_not_nil assigns(:customer)
    assert_not_nil assigns(:invoice)
    assert assigns(:invoice).new_record?
  end

  test "new should not work if user is not logged in" do
    get :new, customer_id: customers(:one)
    assert_redirected_to new_user_session_path
  end

  test "new should not work if the customer does not belong to the user" do
    sign_in :user, users(:user_without_properties)
    get :new, customer_id: customers(:one)
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "create should create invoice and transaction" do
    sign_in :user, users(:one)

    assert_difference ['Invoice.count', 'Tran.count'] do
      post :create, customer_id: customers(:one), invoice: {
        customer_id: customers(:three).id,
        amount: "500",
        date: "03/10/2016",
        memo: "this is the memo"
      }
    end

    assert_equal assigns(:invoice).customer.balance, 500.00
    assert_redirected_to edit_customer_invoice_path(assigns(:invoice).customer, assigns(:invoice))
    assert_equal "Invoice successfully saved", flash[:success]
  end

  test "create should only work if the user is logged in" do
    post :create, customer_id: customers(:one)
    assert_redirected_to new_user_session_path
  end

  test "create should not work with invalid form data" do
    sign_in :user, users(:one)

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
    sign_in :user, users(:user_without_properties)
    post :create, customer_id: users(:one)
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "get edit" do
    sign_in :user, users(:one)
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
    sign_in :user, users(:user_without_properties)
    get :edit, customer_id: customers(:one), id: invoices(:one)
    assert_redirected_to root_path
  end

  test "edit should only work if invoice belongs to user" do
    sign_in :user, users(:one)
    get :edit, customer_id: customers(:one), id: invoices(:two)
    assert_redirected_to root_path
  end



  test "update should successfully update invoice" do
    sign_in :user, users(:one)

    put :update, customer_id: customers(:one), id: invoices(:one), invoice: {
      customer_id: customers(:three).id,
      amount: "200",
      date: "05/08/2016",
      memo: "blah memo"
    }

    assert_redirected_to edit_customer_invoice_path(assigns(:invoice).customer, assigns(:invoice))
    assert_equal assigns(:invoice).amount, 200
    assert_equal assigns(:invoice).date, Date.strptime("05/08/2016", "%d/%m/%Y")
    assert_equal assigns(:invoice).memo, "blah memo"
  end

  test "update should not work with invalid data" do
    sign_in :user, users(:one)

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
    sign_in :user, users(:user_without_properties)

    put :update, customer_id: customers(:one), id: invoices(:one)
    assert_redirected_to root_path
  end

  test "update should only work if invoice belongs to user" do
    sign_in :user, users(:one)
    get :edit, customer_id: customers(:one), id: invoices(:two)
    assert_redirected_to root_path
  end



  test "destroy should successfully destroy invoice" do
    sign_in :user, users(:one)

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
    sign_in :user, users(:user_without_properties)

    assert_difference 'Invoice.count', 0 do
      delete :destroy, customer_id: customers(:one), id: invoices(:one)
    end

    assert_redirected_to root_path
  end

  test "destroy should only work if the invoice belongs to the user" do
    sign_in :user, users(:one)

    assert_difference 'Invoice.count', 0 do
      delete :destroy, customer_id: customers(:one), id: invoices(:two)
    end

    assert_redirected_to root_path
  end

  test "show should redirect to edit" do
    sign_in :user, users(:one)
    get :show, customer_id: customers(:one), id: invoices(:one)

    assert_redirected_to edit_customer_invoice_path
  end
end
