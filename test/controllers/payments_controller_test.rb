class PaymentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "get new" do
    sign_in :user, users(:one)
    get :new, customer_id: users(:one)
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:customer)
    assert_not_nil assigns(:payment)
    assert assigns(:payment).new_record?
  end

  test "should only allow new if customer belongs to user" do
    sign_in :user, users(:user_without_properties)
    get :new, customer_id: users(:one)
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "new should redirect to sign in if no current user" do
    get :new, customer_id: users(:one)
    assert_redirected_to new_user_session_path
  end

  test "create should create user" do
    sign_in :user, users(:one)

    assert_difference 'Payment.count', 1 do
      post :create, customer_id: users(:one), payment: {
        amount: "300",
        date: "03/11/2016",
        memo: "hello world",
      }
    end

    assert_redirected_to new_customer_payment_path(customers(:one))
    assert_not_nil assigns(:payment)
    assert_equal "Payment successfully created", flash[:success]
  end

  test "create should fail if form is filled out incorrectly" do
    sign_in :user, users(:one)

    assert_difference 'Payment.count', 0 do
      post :create, customer_id: users(:one), payment: {
        amount: nil,
        # date: nil,
        memo: " ",
      }
    end

    assert_template :new
    # assert_select 'form-errors'
  end
end
