class PaymentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "index should redirect to customer" do
    sign_in :user, users(:one)
    get :index, customer_id: customers(:one)
    assert_redirected_to customers(:one)
  end

  test "get new" do
    sign_in :user, users(:one)
    get :new, customer_id: customers(:one)
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:customer)
    assert_not_nil assigns(:payment)
    assert assigns(:payment).new_record?
  end

  test "should only allow new if customer belongs to user" do
    sign_in :user, users(:user_without_properties)
    get :new, customer_id: customers(:one)
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "new should redirect to sign in if no current user" do
    get :new, customer_id: customers(:one)
    assert_redirected_to new_user_session_path
  end



  test "create should create payment" do
    sign_in :user, users(:one)

    assert_difference ['Payment.count', 'Tran.count'], 1 do
      post :create, customer_id: customers(:one), payment: {
        customer_id: customers(:one).id,
        amount: "300",
        date: "03/11/2016",
        memo: "hello world",
      }
    end

    assert_equal assigns(:payment).account, accounts(:five)
    assert_equal assigns(:payment).customer.balance, -300.00
    assert_redirected_to customers(:one)
    assert_not_nil assigns(:payment)
    assert_equal "Payment successfully created", flash[:success]
  end

  test "create should fail if form is filled out incorrectly" do
    sign_in :user, users(:one)

    assert_difference 'Payment.count', 0 do
      post :create, customer_id: customers(:one), payment: {
        amount: nil,
        date: nil,
        memo: " ",
      }
    end

    assert_template :new
    assert_select '.form-errors'
  end

  test "create should only work if customer belongs to user" do
    sign_in :user, users(:user_without_properties)
    post :create, customer_id: customers(:one)
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "create should only work if user is signed in" do
    post :create, customer_id: customers(:one)
    assert_redirected_to new_user_session_path
  end

  test "get edit" do
    sign_in :user, users(:one)
    get :edit, customer_id: customers(:one), id: payments(:one)
    assert_response :success
    assert_template :edit
    assert_not_nil assigns(:payment)
    assert_equal assigns(:payment), payments(:one)
  end

  test "edit should only work if user is logged in" do
    get :edit, customer_id: customers(:one), id: payments(:one)
    assert_redirected_to new_user_session_path
  end

  test "edit should only work if customer belongs to user" do
    sign_in :user, users(:user_without_properties)
    get :edit, customer_id: customers(:one), id: payments(:one)
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end



  test "update should successfully update payment" do
    sign_in :user, users(:one)
    put :update, customer_id: customers(:one), id: payments(:one), payment: {
      amount: "200",
      date: "05/08/2016",
      memo: "blah memo",
    }

    assert_equal assigns(:payment).amount, 200
    assert_equal assigns(:payment).date, Date.strptime("05/08/2016", "%d/%m/%Y")
    assert_equal assigns(:payment).memo, "blah memo"

    assert_redirected_to edit_customer_payment_path
  end

  test "update should not work if the payment has been deposited" do
    sign_in :user, users(:one)

    payments(:one).update_attribute :deposit, deposits(:one)

    put :update, customer_id: customers(:one), id: payments(:one), payment: {
      amount: "500",
      date: "06/02/2016",
      memo: "foobar",
    }

    assert_not_equal assigns(:payment).amount, 500
    assert_not_equal assigns(:payment).date, "06/02/2016".to_date
    assert_not_equal assigns(:payment).memo, "foobar"
    assert_template :edit
  end

  test "update should not save with invalid data" do
    sign_in :user, users(:one)

    put :update, customer_id: customers(:one), id: payments(:one), payment: {
      amount: "",
      date: "",
      memo: "",
    }

    assert_template :edit
    assert_select '.form-errors'
  end

  test "update should not work if user is not logged in" do
    put :update, customer_id: customers(:one), id: payments(:one)
    assert_redirected_to new_user_session_path
  end

  test "update should not work if customer does not belong to user" do
    sign_in :user, users(:user_without_properties)

    put :update, customer_id: customers(:one), id: payments(:one)
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "show should redirect to customer" do
    sign_in :user, users(:one)
    get :show, customer_id: customers(:one), id: payments(:one)
  end

  test "destroy should successfully destroy invoice" do
    sign_in :user, users(:one)

    assert_difference ['Payment.count', 'Tran.count'], -1 do
      delete :destroy, customer_id: customers(:one), id: payments(:one)
    end

    assert_not_nil assigns(:payment)
    assert_redirected_to customers(:one)
  end

  test "destroy should not work if the payment has been deposited" do
    sign_in :user, users(:one)

    payments(:one).update_attribute :deposit, deposits(:one)

    assert_difference ['Payment.count', 'Tran.count'], 0 do
      delete :destroy, customer_id: customers(:one), id: payments(:one)
    end

    assert_not_nil flash[:danger]
  end

  test "destroy should not work if the user is not logged in" do
    assert_difference 'Payment.count', 0 do
      delete :destroy, customer_id: customers(:one), id: payments(:one)
    end

    assert_redirected_to new_user_session_path
  end

  test "destroy should only work if the customer belongs to the user" do
    sign_in :user, users(:user_without_properties)

    assert_difference 'Payment.count', 0 do
      delete :destroy, customer_id: customers(:one), id: payments(:one)
    end

    assert_redirected_to root_path
  end

  test "destroy should only work if the invoice belongs to the user" do
    sign_in :user, users(:one)

    assert_difference 'Payment.count', 0 do
      delete :destroy, customer_id: customers(:one), id: payments(:two)
    end

    assert_redirected_to root_path
  end
end
