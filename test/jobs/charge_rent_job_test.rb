require 'test_helper'

class ChargeRentJobTest < ActiveJob::TestCase
  test "should charge rent" do
    customers(:one).update_attribute(:due_date, Date.today.day.to_s)
    customers(:three).update_attribute(:due_date, Date.today.day.to_s)

    assert_difference ['Invoice.count', 'AccountTran.count', 'Tran.count'], 2 do
      ChargeRentJob.perform_now users(:one).id
    end
  end
end
