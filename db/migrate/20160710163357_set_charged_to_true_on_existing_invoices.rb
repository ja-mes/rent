class SetChargedToTrueOnExistingInvoices < ActiveRecord::Migration[5.0]
  def change
    Invoice.where('due_date <= date').update_all(charged: true)
  end
end
