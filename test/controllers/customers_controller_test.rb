class CustomersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "get index" do
    sign_in :user, users(:one)
    get :index
    assert_response :success
    assert_template :index
  end

  test "index should direct to signin if no current user" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "get new" do
    sign_in :user, users(:one)
    get :new
    assert_response :success
    assert_not_nil assigns(:customer)
  end

  test "new should redirect to signin if no current user" do
    get :new
    assert_redirected_to new_user_session_path
  end
end
