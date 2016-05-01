class Deposit < ActiveRecord::Base
  belongs_to :user
  has_many :payments

  validates :user_id, presence: true
end
