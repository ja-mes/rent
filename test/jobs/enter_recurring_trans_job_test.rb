require 'test_helper'

class EnterRecurringTransJobTest < ActiveJob::TestCase
  test "should enter tran for checks" do
    recurring_trans(:one).update_attribute(:last_charged, Date.today.prev_month)

    assert_difference ['Check.count', 'AccountTran.count'] do
      EnterRecurringTransJob.perform_now users(:one).id
    end
  end

  test "should not enter trans that have been entered in the last month" do
    recurring_trans(:one).update_attribute(:last_charged, Date.today.beginning_of_month)
    Timecop.freeze(Date.today.beginning_of_month + 10.days) do
      assert_difference ['Check.count', 'AccountTran.count'], 0 do
        EnterRecurringTransJob.perform_now users(:one).id
      end
    end
  end

  test "job should be run after the user logs in" do
    assert_enqueued_with(job: EnterRecurringTransJob) do
      User.first.after_database_authentication
    end
  end
end
