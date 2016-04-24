class InvoiceTran < ActiveRecord::Base
  belongs_to :invoice
  #validates :invoice, presence: true
  validates :amount, presence: true
end
