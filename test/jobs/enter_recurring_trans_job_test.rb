require 'test_helper'

#class EnterRecurringTransJobTest < ActiveJob::TestCase
#  test "should enter tran for checks" do
#    recurring_trans(:one).update_attribute(:due_date, Date.today.day.to_s)
#
#    assert_difference ['Check.count', 'AccountTran.count'] do
#      EnterRecurringTransJob.perform_now users(:one).id
#    end
#  end
#end
