class Credit < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :user
  belongs_to :customer
  has_one :tran, as: :transactionable, dependent: :destroy

  # account trans
  has_many :account_trans, as: :account_transable, dependent: :destroy
  validates_presence_of :account_trans
  accepts_nested_attributes_for :account_trans, allow_destroy: :true

  # VAIDATIONS
  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true

  # HOOKS
  before_validation :setup_account_trans, on: :create
  after_create :create_credit_tran, :add_balance
  after_update :update_credit_tran
  after_destroy :remove_balance

  # TRANS
  def create_credit_tran
    self.create_tran(user: self.user, customer: self.customer, date: self.date)
  end

  def update_credit_tran
    self.tran.update_attributes(customer: self.customer, date: self.date)
  end

  # ACCOUNT TRANS
  def setup_account_trans
    self.account_trans.each do |t|
      t.user = self.user
      t.date = self.date
    end
  end

  # BALANCE
  def add_balance
    self.customer.increment!(:balance, by = -self.amount)
  end

  def remove_balance
    self.customer.increment!(:balance, by = self.amount)
  end

  def calculate_balance(old_amount, old_customer)
    if old_customer == self.customer
      self.customer.increment(:balance, by = old_amount)
      self.customer.increment!(:balance, by = -self.amount)
    else
      old_customer.increment!(:balance, by = old_amount)
      self.customer.increment!(:balance, by = -self.amount)
    end
  end
end
