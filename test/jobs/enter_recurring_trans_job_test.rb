require 'test_helper'

class EnterRecurringTransJobTest < ActiveJob::TestCase
  test "should enter tran for checks" do
    recurring_trans(:one).update_attribute(:last_charged, Date.today.prev_month)

    assert_difference ['Check.count', 'AccountTran.count'] do
      EnterRecurringTransJob.perform_now users(:one).id
    end
  end

  test "should not enter trans that have been entered in the last month" do
    recurring_trans(:one).update_attribute(:last_charged, Date.today)
    Timecop.freeze(Date.today + 10.days) do
      assert_difference ['Check.count', 'AccountTran.count'], 0 do
        EnterRecurringTransJob.perform_now users(:one).id
      end
    end
  end
end
