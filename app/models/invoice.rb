class Invoice < ActiveRecord::Base
  belongs_to :user
  belongs_to :customer
  has_one :tran, as: :transactionable, dependent: :destroy

  validates :user_id, presence: true
  validates :customer_id, presence: true
  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true
end
