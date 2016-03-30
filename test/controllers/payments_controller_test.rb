class PaymentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "get new" do
    sign_in :user, users(:one)
    get :new, customer_id: users(:one)
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:customer)
  end
end
