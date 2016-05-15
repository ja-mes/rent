class AccountType < ActiveRecord::Base
  belongs_to :user
  has_many :accounts

end
