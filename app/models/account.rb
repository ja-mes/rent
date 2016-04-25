class Account < ActiveRecord::Base
  belongs_to :user
  has_many :invoice_trans

  validates :user_id, presence: true
  validates :name, presence: true
  validates :balance, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ } 
end
