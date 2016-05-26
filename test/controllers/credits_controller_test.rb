require 'test_helper'

class CreditsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # GET index
  test "get index" do
    sign_in :user, users(:one)

    get :index, customer_id: customers(:one)
    assert_redirected_to customers(:one)
  end

  # GET new
  test "get new" do
    sign_in :user, users(:one)

    get :new, customer_id: customers(:one)
    assert_response :success
    assert_not_nil assigns(:customer)
    assert_not_nil assigns(:credit)
  end

  test "must be logged in" do
    get :new, customer_id: customers(:one)
    assert_redirected_to new_user_session_path
  end

  test "customer must belong to user" do
    sign_in :user, users(:user_without_properties)
    get :new, customer_id: customers(:one)
    assert_redirected_to root_path
  end

  # POST create
  test "post create" do
    sign_in :user, users(:one)

    assert_difference ['Credit.count', 'AccountTran.count', 'Tran.count'] do
      post :create, customer_id: customers(:one), credit: {
        customer_id: customers(:one),
        amount: "500",
        date: "03/10/2016",
        memo: "memo",
        account_trans_attributes: {
          "0" => {
            account_id: accounts(:one).id,
            amount: "500",
            memo: "foo",
            property_id: properties(:four).id
          }
        }
      }
    end

    assert_not_nil assigns(:credit)
    assert_redirected_to edit_customer_credit_path(assigns(:credit).customer, assigns(:credit))
  end
  
  test "post create should not work with invalid data" do
    sign_in :user, users(:one)

    assert_difference ['Credit.count', 'AccountTran.count', 'Tran.count'], 0 do
      post :create, customer_id: customers(:one), credit: {
        amount: nil,
        date: nil,
        memo: nil
      }
    end

    assert_template :new
    assert_select '.form-errors'
  end

  test "post create requires user" do
    post :create, customer_id: customers(:one), credit: {}
    assert_redirected_to new_user_session_path
  end

  test "post create customer must belong to user" do
    sign_in :user, users(:user_without_properties)
    post :create, customer_id: customers(:one)
    assert_redirected_to root_path
  end


  # GET edit
  test "get edit" do
    sign_in :user, users(:one)

    get :edit, customer_id: customers(:one), id: credits(:one)
    assert_response :success
    assert_not_nil assigns(:credit)
  end

  test "get edit requires user" do
   get :edit, customer_id: customers(:one), id: credits(:one)
   assert_redirected_to new_user_session_path
  end

  test "get edit customer must belong to user" do
    sign_in :user, users(:user_without_properties)
    get :edit, customer_id: customers(:one), id: credits(:one)
    assert_redirected_to root_path
  end

  test "get edit credit must belong to user" do
    sign_in :user, users(:one)
    get :edit, customer_id: customers(:one), id: credits(:two)
    assert_redirected_to root_path
  end


  # PUT update
  test "put update" do
    sign_in :user, users(:one)

    put :update, customer_id: customers(:one), id: credits(:one), credit: {
      customer_id: customers(:one).id,
      amount: "700.25",
      date: "03/11/2016",
      memo: "foo",
      account_trans_attributes: {
        "0" => {
          account_id: accounts(:two).id,
          amount: "710.24",
          memo: "foobar",
          property_id: properties(:four).id
        }
      }
    }

    assert_redirected_to edit_customer_credit_path(assigns(:credit).customer, assigns(:credit))
  end

  test "put update should not work with invalid data" do
    sign_in :user, users(:one)


    put :update, customer_id: customers(:one), id: credits(:one), credit: {
      amount: "",
      date: "",
      memo: "",
    }

    assert_template :edit
    assert_select '.form-errors'
  end

  test "put update requires logged in user" do
    put :update, customer_id: customers(:one), id: credits(:one)
    assert_redirected_to new_user_session_path
  end

  test "put update customer must belong to user" do
    sign_in :user, users(:user_without_properties)

    put :update, customer_id: customers(:one), id: credits(:one)
    assert_redirected_to root_path
  end

  test "put update requires credit to belong to user" do
    sign_in :user, users(:one)
    put :update, customer_id: customers(:one), id: credits(:two)
    assert_redirected_to root_path
  end


  # GET show
  test "show should redirect to edit path" do
    sign_in :user, users(:one)

    get :show, customer_id: customers(:one), id: credits(:one)
    assert_redirected_to edit_customer_credit_path(customers(:one), credits(:one))
  end


  # DELETE destroy
  test "delete destroy" do
    sign_in :user, users(:one)

    assert_difference ['Credit.count', 'Tran.count', 'AccountTran.count'], -1 do
      delete :destroy, customer_id: customers(:one), id: credits(:one)
    end
  end

  test "delete destroy requries logged in user" do
    assert_difference ['Credit.count', 'Tran.count', 'AccountTran.count'], 0 do
      delete :destroy, customer_id: customers(:one), id: credits(:one)
    end
  end

  test "delete destroy requires customer to belong to user" do
    sign_in :user, users(:user_without_properties)

    assert_difference ['Credit.count', 'Tran.count', 'AccountTran.count'], 0 do
      delete :destroy, customer_id: customers(:one), id: credits(:one)
    end

    assert_redirected_to root_path
  end

  test "delete requires credit to belong to user" do
    sign_in :user, users(:one)

    assert_difference ['Credit.count', 'Tran.count', 'AccountTran.count'], 0 do
      delete :destroy, customer_id: customers(:one), id: credits(:two)
    end

    assert_redirected_to root_path
  end
end
