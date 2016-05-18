class AccountsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "get index" do
    sign_in :user, users(:one)

    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:accounts)
  end

  test "get index should not work if user is not logged in" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "get new" do
    sign_in :user, users(:one)

    get :new
    assert_response :success
    assert_not_nil assigns(:account)
  end

  test "get new should not work if the user is not logged in" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "post create" do
    sign_in :user, users(:one)

    assert_difference 'Account.count' do
      post :create, account: {
        name: "Foo",
        account_type_id: account_types(:income)
      }
    end

    assert_not_nil assigns(:account)
    assert_not_nil assigns(:account).user
  end

  test "post create shoud fail with invalid data" do
    sign_in :user, users(:one)

    assert_difference 'Account.count', 0 do
      post :create, account: {
        name: "",
        account_type_id: ""
      }
    end

    assert_template 'new'
  end

  test "post create should not work if user is not logged in" do
    post :create, account: {}

    assert_redirected_to new_user_session_path
  end

  test "get show" do
    sign_in :user, users(:one)

    get :show, id: accounts(:one)
    assert_response :success
    assert_template :show
    assert_not_nil assigns(:account)
    assert_equal assigns(:negate), !assigns(:account).account_type.inc
  end

  test "get show should not work if user is not logged in" do
    get :show, id: accounts(:one)
    assert_redirected_to new_user_session_path
  end

  test "get edit" do
    sign_in :user, users(:one)

    get :edit, id: accounts(:one)
    assert_response :success
    assert_template :edit
    assert_not_nil assigns(:account)
  end

  test "get edit should not work if the user is not signed in" do
    get :edit, id: accounts(:one)
    assert_redirected_to new_user_session_path
  end

  test "post update" do
    sign_in :user, users(:one)

    post :update, id: accounts(:one), account: {
      name: "Bar"
    }

    assert_equal assigns(:account).name, "Bar"
  end

  test "post update should not update type" do
    sign_in :user, users(:one)

    post :update, id: accounts(:one), account: {
      name: "Bar",
      account_type_id: account_types(:expenses)
    }

    assert_equal assigns(:account).account_type, account_types(:income)
  end

  test "post update should not work if invalid form data is submitted" do
    sign_in :user, users(:one)

    post :update, id: accounts(:one), account: {
      name: ""
    }

    assert_template :edit
  end

  test "post update should not work if user is not logged in" do
    post :update, id: accounts(:one), account: {}
    assert_redirected_to new_user_session_path
  end
end
