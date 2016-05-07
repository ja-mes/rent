require 'test_helper'

class NotesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  # GET index
  test "get index" do
    sign_in :user, users(:one)

    get :index, customer_id: customers(:one)
    assert_response :success
    assert_template :index

    assert_not_nil assigns(:note)
    assert_not_nil assigns(:notes)
  end

  test "edit should only work if the user is logged in" do
    get :index, customer_id: customers(:one)
    assert_redirected_to new_user_session_path
  end

  test "get index should not work if the customer does not belong to the user" do
    sign_in :user, users(:two)

    get :index, customer_id: customers(:one)
    assert_redirected_to root_path
  end

  
  # GET new
  test "get new" do
    sign_in :user, users(:one)

    xhr :get, :new, customer_id: customers(:one)
    assert_response :success
    assert assigns(:note).new_record?
  end

  test "get new requires user" do
    xhr :get, :new, customer_id: customers(:one)
    assert_response :unauthorized
  end

  test "get new requires same customer user" do
    sign_in :user, users(:user_without_properties)
    xhr :get, :new, customer_id: customers(:one)
    assert_redirected_to root_path
  end


  # POST create
  test "post create" do
    sign_in :user, users(:one)

    assert_difference 'Note.count' do
      xhr :post, :create, customer_id: customers(:one), note: {
        content: "foobar"
      }
    end

    assert_equal assigns(:note).content, "foobar"
  end

  test "post create requires user" do
    xhr :post, :create, customer_id: customers(:one), note: {}
    assert_response :unauthorized
  end

  test "post create requires same customer user" do
    sign_in :user, users(:user_without_properties)
    post :create, customer_id: customers(:one), note: { content: "foobar" }
    assert_redirected_to root_path
  end


  # GET edit
  test "get edit" do
    sign_in :user, users(:one)

    xhr :get, :edit, customer_id: customers(:one), id: notes(:one)
    assert_response :success
    assert_equal assigns(:note), notes(:one)
  end

  test "get edit requires user" do
    xhr :get, :edit, customer_id: customers(:one), id: notes(:one)
    assert_response :unauthorized
  end

  test "get edit requires customer user" do
    sign_in :user, users(:user_without_properties)
    xhr :get, :edit, customer_id: customers(:one), id: notes(:one)
    assert_redirected_to root_path
  end

  test "get edit requires note user" do
    sign_in :user, users(:one)
    xhr :get, :edit, customer_id: customers(:one), id: notes(:two)
    assert_redirected_to root_path
  end


  # PUT update
  test "put update" do
    sign_in :user, users(:one)

    note = notes(:one)
    xhr :put, :update, customer_id: customers(:one), id: note, note: {
      content: "the new content"
    }

    note.reload
    assert_equal note.content, "the new content"
  end

  test "put update requires user" do
    xhr :put, :update, customer_id: customers(:one), id: notes(:one), note: {}
    assert_response :unauthorized
  end

  test "put update requires customer user" do
    sign_in :user, users(:user_without_properties)
    put :update, customer_id: customers(:one), id: notes(:one), note: {}
    assert_redirected_to root_path
  end

  test "put update requires note user" do
    sign_in :user, users(:one)
    put :update, customer_id: customers(:one), id: notes(:two), note: {}
    assert_redirected_to root_path
  end


  # DELETE destroy
  test "delete destroy" do
    sign_in :user, users(:one)
    
    assert_difference 'Note.count', -1 do
      xhr :delete, :destroy, customer_id: customers(:one), id: notes(:one)
    end

    assert_not_nil assigns(:note)
  end

  test "delete destroy requires logged in user" do
    assert_difference 'Note.count', 0 do
      xhr :delete, :destroy, customer_id: customers(:one), id: notes(:one)
    end

    assert_response :unauthorized
  end

  test "delete destroy requires same customer user" do
    sign_in :user, users(:user_without_properties)

    assert_difference 'Note.count', 0 do
      delete :destroy, customer_id: customers(:one), id: notes(:one)
    end

    assert_redirected_to root_path
  end

  test "delete destroy requires same note user" do
    sign_in :user, users(:one)

    assert_difference 'Note.count', 0 do
      delete :destroy, customer_id: customers(:one), id: notes(:two)
    end

    assert_redirected_to root_path
  end
end
