class Register < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :balance, presence: true
  validates :name, presence: true

  def set_beginning_balance(amount) 
    increment!(:balance, amount)
  end
end
