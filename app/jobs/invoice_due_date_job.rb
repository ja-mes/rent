class InvoiceDueDateJob < ApplicationJob
  queue_as :default

  def perform(invoice_id)
    Invoice.find(invoice_id).inc_balance
  end
end
