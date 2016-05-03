class Deposit < ActiveRecord::Base
  belongs_to :user
  has_many :payments
  has_one :tran, as: :transactionable, dependent: :destroy

  validates :user_id, presence: true
  validates :date, presence: true
  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than_or_equal_to: 0 }

  after_create do
    self.create_tran(user: self.user, date: self.date)
  end
end
