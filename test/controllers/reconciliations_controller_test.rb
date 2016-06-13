require 'test_helper'

class ReconciliationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # GET index
  test "get index" do
    sign_in :user, users(:one)
    get :index
  end
end
