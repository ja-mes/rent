require 'test_helper'

class DepositsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # GET index
  test "get index" do
    sign_in :user, users(:one)
    get :index
    assert_redirected_to new_deposit_path
  end


  # GET new
  test "get new" do
    sign_in :user, users(:one)
    get :new
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:deposit)
    assert_equal assigns(:account), accounts(:five)
    assert_not_nil assigns(:payments).length, 1
  end


  # POST create
  test "post create" do
    sign_in :user, users(:one)

    payment = payments(:one)
    payment2 = payments(:four)

    assert_difference ['Deposit.count', 'Tran.count'] do
      post :create, deposit: {
        date: "03/10/2016",
        discrepancies: 20.5,
        payment: {
          "#{payment.id}" => {
            "selected": "on"
          },
          "#{payment2.id}" => {
            "selected": "on"
          }
        }
      }
    end

    deposit = assigns(:deposit)
    payment.reload
    payment2.reload

    assert_equal deposit.date, "03/10/2016".to_date
    assert_equal deposit.discrepancies, 20.5

    assert_equal payment.deposit, deposit
    assert_equal payment2.deposit, deposit
    assert_equal deposit.amount, (payment.amount + payment2.amount + deposit.discrepancies)
    assert_equal accounts(:four).balance, (payment.amount + payment2.amount + deposit.discrepancies)
    assert_equal deposit.tran.date, deposit.date
  end

  test "post create should work without deposit discrepancies" do
    sign_in :user, users(:one)

    payment = payments(:one)
    
    assert_difference ['Deposit.count', 'Tran.count'] do
      post :create, deposit: {
        date: "03/10/2016",
        payment: {
          "#{payment.id}" => {
            "selected": "on"
          },
        }
      }
    end

    assert_equal assigns(:deposit).amount, payment.amount
  end

  test "create should not work if no payments are specified" do
    sign_in :user, users(:one)

    assert_difference ['Deposit.count', 'Tran.count'], 0 do
      post :create, deposit: {
        date: "03/10/2016",
        payment: {}
      }
    end

    assert assigns(:deposit).errors.count > 0
  end

  test "create should only work if the user is logged in" do
    assert_difference ['Deposit.count', 'Tran.count'], 0 do
      post :create, deposit: {}
    end

    assert_redirected_to new_user_session_path
  end


  # GET show
  test "show should redirect to edit path" do
    sign_in :user, users(:one)

    get :show, id: deposits(:one)
    assert_redirected_to edit_deposit_path(deposits(:one))
  end


  # GET edit
  test "get edit should display deposit" do
    sign_in :user, users(:one)
    get :edit, id: deposits(:one)
    assert_equal assigns(:payments), deposits(:one).payments
  end

  test  "get edit should only work if the user is logged in" do
    get :edit, id: deposits(:one)
    assert_redirected_to new_user_session_path
  end

  test "get edit should only work if the deposit belongs to the user" do
    sign_in :user, users(:user_without_properties)
    get :edit, id: deposits(:one)
    assert_redirected_to root_path
  end


  # PUT update
  test "update should successfully update deposit" do
    sign_in :user, users(:one)

    payment = payments(:three)
    payment2 = payments(:five)

    put :update, id: deposits(:one), deposit: {
      date:  "5/10/2016",
      discrepancies: 80.25,
      payment: {
        "#{payment.id}" => {
          "selected": "on"
        }
      }
    }

    deposit = assigns(:deposit)

    assert_equal deposit.date, "5/10/2016".to_date
    assert_equal deposit.discrepancies, 80.25
    assert_equal deposit.amount, (9.99 - payment2.amount + deposit.discrepancies)
      
    assert_equal deposit.payments.count, 1
  end

  test "update should work without discrepancies" do
    sign_in :user, users(:one)

    payment = payments(:three)

    put :update, id: deposits(:one), deposit: {
      date: "5/10/2016",
      "#{payment.id}" => {
        "selected": "on"
      }
    }

    assert_redirected_to assigns(:deposit)
  end

  test "update should not remove payments if they are all unchecked" do
    sign_in :user, users(:one)

    put :update, id: deposits(:one), deposit: {
      date:  "5/10/2016",
      payments: {}
    }

    assert assigns(:deposit).payments.count > 0
  end

  test "update should not work if user is not logged in" do
    put :update, id: deposits(:one), deposit: {}
    assert_redirected_to new_user_session_path
  end

  test "update should not work if the deposit does not belong to the user" do
    sign_in :user, users(:user_without_properties)
    put :update, id: deposits(:one), deposit: {}
    assert_redirected_to root_path
  end


  # DELETE destroy
  test "destroy should destroy deposit" do
    sign_in :user, users(:one)

    deposits(:one).payments = []
    deposits(:one).payments << payments(:one)
    deposits(:one).payments << payments(:four)

    assert_difference 'Deposit.count', -1 do
      delete :destroy, id: deposits(:one)
    end

    assigns(:deposit).payments.each do |p|
      assert_nil p.deposit
    end
  end
end 
