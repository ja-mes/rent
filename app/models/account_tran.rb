class AccountTran < ActiveRecord::Base
  belongs_to :user
  belongs_to :accounts
  belongs_to :properties
  #belongs_to :invoice
  belongs_to :account_transable, polymorphic: true

  validates :user_id, presence: true
  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than_or_equal_to: 0 }
end
