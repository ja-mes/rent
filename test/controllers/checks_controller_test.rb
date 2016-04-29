require 'test_helper'

class ChecksControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "get index should redirect to new check path" do
    sign_in :user, users(:one)
    get :index
    assert_redirected_to new_check_path
  end

  test "get new should setup vars" do
    sign_in :user, users(:one)

    get :new
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:check)
    assert_not_nil assigns(:check).account_trans
    assert_not_nil assigns(:accounts)
    assert_not_nil assigns(:properties)
  end

  test "post create" do
    sign_in :user, users(:one)

    assert_difference ['Check.count', 'AccountTran.count'] do
      post :create, check: {
        num: "2",
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

    assert_not_nil assigns(:check)
    assert_equal -assigns(:check).amount, accounts(:four).balance
    assert_redirected_to assigns(:check)
  end

  test "get show" do
    sign_in :user, users(:one)
    get :show, id: checks(:one)
    assert_redirected_to edit_check_path(checks(:one))
  end

  test "get edit" do
    sign_in :user, users(:one)
    get :edit, id: checks(:one)
    assert_response :success
    assert_template :edit
  end

  test "put update" do
    sign_in :user, users(:one)

    put :update, id: checks(:one), check: {
      num: "3",
      amount: "600",
      date: "03/11/2016",
      memo: "test",
      account_trans_attributes: {
        "0" => {
          account_id: accounts(:two).id,
          amount: 600,
          memo: "test2",
          property_id: properties(:one).id
        }
      }
    }

    check = assigns(:check)
    assert_redirected_to check
    assert_equal check.amount, 600
    assert_equal check.date, Date.strptime("3/11/2016", "%d/%m/%Y")

  end

  test "destroy" do
  end
end
