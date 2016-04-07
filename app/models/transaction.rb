class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :customer
  belongs_to :transactionable, polymorphic: true

  validates :user_id, presence: true
  validates :customer_id, presence: true
end