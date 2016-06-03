require 'test_helper'

class ChargeRentJobTest < ActiveJob::TestCase
  test "should charge rent" do
    customers(:one).update_attribute(:last_charged, Date.today.prev_month)
    customers(:three).update_attributes(last_charged: Date.today.prev_month, active: true)

    assert_difference ['Invoice.count', 'AccountTran.count', 'Tran.count'], 2 do
      ChargeRentJob.perform_now users(:one).id
    end
  end

  test "rent should be charged after user is logged in" do
    assert_enqueued_with(job: ChargeRentJob) do
      User.first.after_database_authentication
    end
  end
end
