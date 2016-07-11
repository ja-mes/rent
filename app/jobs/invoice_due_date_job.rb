class InvoiceDueDateJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    user.invoices.includes(:customer).where("due_date <= ? AND charged = false", Date.today).find_each do |i|
      i.customer.increment!(:balance, by = i.amount)
      i.update_attribute(:charged, true)
    end
  end
end
