require 'test_helper'

class NotesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  # GET index
  test "get index" do
    sign_in users(:one), scope: :user

    get :index, params: { customer_id: customers(:one) }
    assert_response :success
    assert_template :index

    assert_not_nil assigns(:note)
    assert_not_nil assigns(:notes)
  end

  test "edit should only work if the user is logged in" do
    get :index, params: { customer_id: customers(:one) }
    assert_redirected_to new_user_session_path
  end

  test "get index should not work if the customer does not belong to the user" do
    sign_in users(:two), scope: :user

    get :index, params: { customer_id: customers(:one) }
    assert_redirected_to root_path
  end

  
  # GET new
  test "get new" do
    sign_in users(:one), scope: :user

    get :new, xhr: true, params: { customer_id: customers(:one) }
    assert_response :success
    assert assigns(:note).new_record?
  end

  test "get new requires user" do
    get :new, xhr: true,  params: { customer_id: customers(:one) }
    assert_response :unauthorized
  end

  test "get new requires same customer user" do
    sign_in users(:user_without_properties), scope: :user
    get :new, xhr: true, params: { customer_id: customers(:one) }
    assert_redirected_to root_path
  end


  # POST create
  test "post create" do
    sign_in users(:one), scope: :user

    assert_difference 'Note.count' do
      post :create, xhr: true, params: { customer_id: customers(:one), note: {
        content: "foobar",
        date: "05/08/2016"
      }}
    end

    assert_equal assigns(:note).content, "foobar"
    assert_equal assigns(:note).date, Date.strptime("05/08/2016", "%d/%m/%Y") 
  end

  test "post create requires user" do
    post :create, xhr: true, params: { customer_id: customers(:one), note: {} }
    assert_response :unauthorized
  end

  test "post create requires same customer user" do
    sign_in users(:user_without_properties), scope: :user
    post :create, params: { customer_id: customers(:one), note: { content: "foobar" } }
    assert_redirected_to root_path
  end


  # GET edit
  test "get edit" do
    sign_in users(:one), scope: :user

    get :edit, xhr: true, params: { customer_id: customers(:one), id: notes(:one) }
    assert_response :success
    assert_equal assigns(:note), notes(:one)
  end

  test "get edit requires user" do
    get :edit, xhr: true, params: { customer_id: customers(:one), id: notes(:one) }
    assert_response :unauthorized
  end

  test "get edit requires customer user" do
    sign_in users(:user_without_properties), scope: :user
    get :edit, xhr: true, params: { customer_id: customers(:one), id: notes(:one) }
    assert_redirected_to root_path
  end

  test "get edit requires note user" do
    sign_in users(:one), scope: :user
    get :edit, xhr: true, params: { customer_id: customers(:one), id: notes(:two) }
    assert_redirected_to root_path
  end


  # PUT update
  test "put update" do
    sign_in users(:one), scope: :user

    note = notes(:one)
    put :update, xhr: true, params: { customer_id: customers(:one), id: note, note: {
      content: "the new content",
      date: "04/07/2016"
    }}

    note.reload
    assert_equal note.content, "the new content"
    assert_equal assigns(:note).date, Date.strptime("04/07/2016", "%d/%m/%Y") 
  end

  test "put update requires user" do
    put :update, xhr: true, params: { customer_id: customers(:one), id: notes(:one), note: {} }
    assert_response :unauthorized
  end

  test "put update requires customer user" do
    sign_in users(:user_without_properties), scope: :user
    put :update, params: { customer_id: customers(:one), id: notes(:one), note: {} }
    assert_redirected_to root_path
  end

  test "put update requires note user" do
    sign_in users(:one), scope: :user
    put :update, params: { customer_id: customers(:one), id: notes(:two), note: {} }
    assert_redirected_to root_path
  end


  # DELETE destroy
  test "delete destroy" do
    sign_in users(:one), scope: :user
    
    assert_difference 'Note.count', -1 do
      delete :destroy, xhr: true, params: { customer_id: customers(:one), id: notes(:one) }
    end

    assert_not_nil assigns(:note)
  end

  test "delete destroy requires logged in user" do
    assert_difference 'Note.count', 0 do
      delete :destroy, xhr: true, params: { customer_id: customers(:one), id: notes(:one) }
    end

    assert_response :unauthorized
  end

  test "delete destroy requires same customer user" do
    sign_in users(:user_without_properties), scope: :user

    assert_difference 'Note.count', 0 do
      delete :destroy, params: { customer_id: customers(:one), id: notes(:one) }
    end

    assert_redirected_to root_path
  end

  test "delete destroy requires same note user" do
    sign_in users(:one), scope: :user

    assert_difference 'Note.count', 0 do
      delete :destroy, params: { customer_id: customers(:one), id: notes(:two) }
    end

    assert_redirected_to root_path
  end
end
