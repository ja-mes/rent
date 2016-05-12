class Account < ActiveRecord::Base
  belongs_to :user
  has_many :account_trans
  has_many :payments

  validates :user_id, presence: true
  validates :name, presence: true
  validates :balance, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ } 

  # XXX: When making an addition to this list updated calculate total method in account_tran.rb
  validates :account_type, inclusion: ["Bank", "Income", "Other Current Assets", "Other Income", "Expenses"]
end
