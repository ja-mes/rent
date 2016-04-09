class Invoice < ActiveRecord::Base
  belongs_to :user
  belongs_to :customer
  has_one :transactions, as: :transactionable, dependent: :destroy

  validates :user_id, presence: true
  validates :customer_id, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true
end
