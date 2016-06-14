require 'test_helper'

class ReconciliationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # GET index
  test "get index" do
    sign_in :user, users(:one)
    get :index
  end

  test "get index requires logged in user" do
    get :index
    assert_redirected_to new_user_session_path
  end

  
  # GET new
  test "get new" do
    sign_in :user, users(:one)
    get :new
    assert_response :success

    assert_not_nil assigns(:reconciliation)
    assert_not_nil assigns(:checks)
    assert_not_nil assigns(:deposits)
    assert_not_nil assigns(:register)
  end

  test "get new requires logged in user" do
    get :new
    assert_redirected_to new_user_session_path
  end


  # POST create
  test "post create" do
    sign_in :user, users(:one)

    checks = Check.where(user: users(:one), cleared: false)
    deposits = Deposit.where(user: users(:one), cleared: false)

    assert_difference ["Reconciliation.count"] do
      post :create, reconciliation: {
        date: Date.today,
        ending_balance: 30, checks: {
          checks.first.id.to_s => {"selected"=>"on"}, checks.second.id.to_s => {"selected"=>"on"} 
        }, deposits: {
          deposits.first.id.to_s => {"selected"=>"on"}
        }}
    end

    assert_redirected_to reconciliations_path
    assert_not_nil flash[:success]
  end

  test "post create requires logged in user" do
    post :create, reconciliation: {}
    assert_redirected_to new_user_session_path
  end

  
  # DELETE destroy
  test "delete destroy" do
    sign_in :user, users(:one)

    assert_difference 'Reconciliation.count', -1 do
      delete :destroy, id: reconciliations(:one)
    end
  end
end
