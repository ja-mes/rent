class Tran < ActiveRecord::Base
  belongs_to :user
  belongs_to :customer
  belongs_to :transactionable, polymorphic: true

  validates :user_id, presence: true
end
