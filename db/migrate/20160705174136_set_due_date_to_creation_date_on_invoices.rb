class SetDueDateToCreationDateOnInvoices < ActiveRecord::Migration[5.0]
  def change
    Invoice.all.find_each do |i|
      i.update_attribute(:due_date, i.date)
    end
  end
end
