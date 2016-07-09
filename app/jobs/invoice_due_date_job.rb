class InvoiceDueDateJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    user.invoices.includes(:customer).where(due_date: Date.today, charged: false).find_each do |i|
      customer.increment!(:balance, by = i.amount)
    end
  end
end
