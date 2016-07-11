require 'test_helper'

class InvoiceDueDateJobTest < ActiveJob::TestCase
  test "should inc balances" do

    invoices(:one).update_attributes(charged: false, due_date: Date.yesterday, amount: 20, skip_tran_validation: true)
    invoices(:two).update_attributes(user: users(:one), customer: customers(:one), charged: false, due_date: 5.days.ago, amount: 50, skip_tran_validation: true)

    assert_difference 'customers(:one).reload.balance', 70 do
      InvoiceDueDateJob.perform_now users(:one).id
    end
  end
end
