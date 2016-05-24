class AccountType < ActiveRecord::Base
  belongs_to :user
  has_many :accounts

  validates :user_id, presence: true
  validates :name, presence: true
end
