class Deposit < ActiveRecord::Base
  belongs_to :user
  has_many :payments
  has_one :tran, as: :transactionable, dependent: :destroy

  validates :user_id, presence: true

  after_create do
    self.create_tran(user: self.user)
  end
end
