class Credit < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :user
  belongs_to :customer
  has_one :tran, as: :transactionable, dependent: :destroy

  # VAIDATIONS
  validates :amount, presence: true
  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true

  # HOOKS
  after_create :create_credit_tran
  after_update :update_tran

  # TRANS
  def create_credit_tran
    self.create_tran(user: self.user, customer: self.customer, date: self.date)
  end

  def update_credit_tran
    self.tran.update_attributes(customer: self.customer, date: self.date)
  end
end
