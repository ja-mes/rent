require 'test_helper'

class RecurringTransControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "post create should work for checks" do
    sign_in :user, users(:one)

    assert_difference "RecurringTran.count" do
      xhr :post, :create, id: checks(:one).id, type: "Check", due_date: "5"
    end
  end
end
