require 'test_helper'

class ChargeRentJobTest < ActiveJob::TestCase
  test "should charge rent" do
    customers(:one).update_attribute(:last_charged, Date.today.prev_month)
    customers(:three).update_attributes(last_charged: Date.today.prev_month, active: true)

    assert_difference ['Invoice.count', 'AccountTran.count', 'Tran.count'], 2 do
      ChargeRentJob.perform_now users(:one).id
    end
  end

  test "charge rent job should not work for inactive customers" do
    customers(:one).update_attribute(:last_charged, Date.today)
    customers(:three).update_attributes(last_charged: Date.today.prev_month)

    assert_difference ['Invoice.count', 'AccountTran.count', 'Tran.count'], 0 do
      ChargeRentJob.perform_now users(:one).id
    end
  end

  test "rent should be charged after user is logged in" do
    assert_enqueued_with(job: ChargeRentJob) do
      User.first.after_database_authentication
    end
  end

  test "rent should not be charged if customer_type is not tenant" do
    customers(:one).update_attributes(last_charged: Date.today.prev_month, customer_type: "blank")
    customers(:three).update_attributes(last_charged: Date.today.prev_month, active: true, customer_type: "blank")

    assert_difference ['Invoice.count', 'AccountTran.count', 'Tran.count'], 0 do
      ChargeRentJob.perform_now users(:one).id
    end
  end
end
