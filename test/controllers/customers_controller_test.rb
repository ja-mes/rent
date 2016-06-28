require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test "get index" do
    sign_in users(:one), scope: :user
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:customers)
  end

  test "index should redirect to signin if no current user" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "get new" do
    sign_in users(:one), scope: :user
    get :new
    assert_response :success
    assert_not_nil assigns(:customer)
    assert_not_nil assigns(:properties)
  end

  test "should only get new if there are properties aviable to rent" do
    sign_in users(:user_without_properties), scope: :user
    get :new
    assert_redirected_to customers_path
    assert_equal "No properties avaiable to rent", flash[:danger]
  end

  test "new should redirect to signin if no current user" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "create should successfully create customer" do
    sign_in users(:one), scope: :user

    assert_difference 'Customer.count', 1 do
      post :create, params: {customer: {
        due_date: "3",
        first_name: "Joe",
        middle_name: "Foo",
        last_name: "Blah",
        phone: "123567",
        property_id: properties(:one).id,
        deposit: "300",
        rent: "500",
      }}
    end

    assert_not_nil assigns(:properties)
    assert_equal assigns(:customer).full_name, "Joe Foo Blah"
    assert_equal assigns(:customer).user, users(:one)

    assert properties(:one).customers
    assert_redirected_to customer_path assigns(:customer)
    assert_equal "Customer successfully created", flash[:success]
  end

  test "post create should create deposit and prorated rent if should_charge_deposit or should_charge_rent is supplied" do
    sign_in users(:one), scope: :user

    assert_difference ['Invoice.count', 'AccountTran.count', 'Tran.count'], 2 do
      post :create, params: { customer: {
        due_date: "3",
        first_name: "Joe",
        middle_name: "Foo",
        last_name: "Blah",
        phone: "123567",
        property_id: properties(:one).id,
        deposit: "300",
        rent: "500",
        should_charge_deposit: true,
        should_charge_rent: true
      }}
    end

  end

  test "should not allow creation of customer with invalid form" do
    sign_in users(:one), scope: :user

    assert_difference 'Customer.count', 0 do
      post :create, params: { customer: {
        first_name: "",
        middle_name: "",
        last_name: "",
        phone: "",
        property_id: nil,
        deposit: nil
      }}
    end

    assert_template :new
    assert_select '.form-errors'

  end

  test "should not be able to create customer if not logged in" do
    post :create
    assert_redirected_to new_user_session_path
  end

  test "show should show customer" do
    sign_in users(:one), scope: :user

    get :show, params: { id: customers(:one) }
    assert_response :success
    assert_template :show
    assert_not_nil assigns(:customer)
  end

  test "show should only show customer if it belongs to current user" do
    sign_in users(:user_without_properties), scope: :user
    get :show, params: { id: customers(:one) }
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "show should redirect to sigin if no current user" do
    get :show, params: { id: customers(:one) }
    assert_redirected_to new_user_session_path
  end

  test "should be able to edit customer" do
    sign_in users(:one), scope: :user

    get :edit, params: { id: customers(:one) }
    assert_response :success
    assert_template :edit
    assert_not_nil assigns(:customer)
    assert_not_nil assigns(:properties )
  end

  test "should only allow users to edit their own customers" do
    sign_in users(:user_without_properties), scope: :user
    get :edit, params: { id: customers(:one) }
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "edit should redirect to signin if no current user" do
    get :edit, params: { id: customers(:one) }
    assert_redirected_to new_user_session_path
  end

  test "should be able to update customer" do
    sign_in users(:one), scope: :user

    put :update, params: { id: customers(:one) , customer: {
      first_name: "Foo",
      last_name: "Blah",
      middle_name: "Bar",
      phone: "1234",
    }}

    assert_equal "Foo", assigns(:customer).first_name
    assert_equal "Blah", assigns(:customer).last_name
    assert_equal "Bar", assigns(:customer).middle_name
    assert_equal "1234", assigns(:customer).phone
  end

  test "update should not save if form is filled out incorrectly" do
    sign_in users(:one), scope: :user

    put :update, params: { id: customers(:one), customer: {
      first_name: "",
      last_name: "",
      middle_name: "",
      phone: "",
    }}

    assert_template :edit
    assert_select '.form-errors'
  end

  test "update should redirect to signin if no current user" do
    post :update, params: { id: customers(:one) }
    assert_redirected_to new_user_session_path
  end

  test "users should only be allowed to update their own customers" do
    sign_in users(:two), scope: :user
    post :update, params: { id: customers(:one) }
 
    assert_redirected_to root_path
    assert_equal "You are not authorized to do that", flash[:danger]
  end

  test "archive should work" do
    sign_in users(:one), scope: :user

    get :archive, params: { id: customers(:one) }
    assert_not_nil assigns(:customer)
    assert_not assigns(:customer).active
    assert_redirected_to assigns(:customer)
    assert_not_nil flash[:danger]
  end

  test "blank should work" do
    sign_in users(:one), scope: :user

    get :blank
    assert_response :success
    assert_not_nil assigns(:customer)
  end

  test "blank requires user" do
    get :blank
    assert_redirected_to new_user_session_path
  end

  test "edit_blank should work" do
    sign_in users(:one), scope: :user

    customers(:one).update_attribute(:customer_type, "blank")
    get :edit, params: { id: customers(:one) }
    assert_response :success
    assert_template :edit_blank
    assert_not_nil assigns(:customer)
  end

  test "edit_blank requires user" do
    customers(:one).update_attribute(:customer_type, "blank")
    get :edit, params: { id: customers(:one) }
    assert_redirected_to new_user_session_path
  end

  test "edit blank requires customer to belong to user" do
    sign_in users(:user_without_properties), scope: :user
    customers(:one).update_attribute(:customer_type, "blank")
    get :edit, params: { id: customers(:one) }
    assert_redirected_to root_path
  end
end
