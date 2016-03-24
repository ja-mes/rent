class CustomersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "get index" do
    sign_in :user, users(:one)
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:customers)
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

  test "create should successfully create customer" do
    sign_in :user, users(:one)

    assert_difference 'Customer.count', 1 do
      post :create, customer: {
        first_name: "Joe",
        middle_name: "Foo",
        last_name: "Blah",
        phone: "123567",
      }
    end

    assert_redirected_to customer_path assigns(:customer)
    assert_equal "Customer successfully created", flash[:success]
  end

  test "should not be able to create customer if not logged in" do
    post :create
    assert_redirected_to new_user_session_path
  end

  test "show should show customer" do
    sign_in :user, users(:one)

    get :show, id: customers(:one)
    assert_response :success
    assert_template :show
    assert_not_nil assigns(:customer)
  end
end
