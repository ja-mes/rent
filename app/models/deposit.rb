class Deposit < ActiveRecord::Base
  belongs_to :user

  has_one :tran, as: :transactionable, dependent: :destroy

  has_many :payments
  validates_presence_of :payments
  has_many :account_trans, as: :account_transable, dependent: :destroy

  validates :user_id, presence: true
  validates :date, presence: true
  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than_or_equal_to: 0 }

  after_create :create_deposit_trans
  after_update :update_tran
  after_destroy :remove_amount

  def create_deposit_trans
    self.create_tran(user: self.user, date: self.date)

    account = self.user.accounts.find_by(name: "Undeposited Funds")
    self.account_trans.create(user: self.user, date: self.date, amount: self.amount, account_id: account.id)
    debugger
  end

  def update_tran 
    self.tran.update_attributes(date: self.date)
  end

  def remove_amount
    account = Account.find_by(user: self.user, name: "Checking")
    account.increment!(:balance, by = -self.amount)
  end

  def calculate_balance(old_amount = nil)
    account = Account.find_by(user: self.user, name: "Checking")
    account.increment(:balance, by = -old_amount) if old_amount
    account.increment!(:balance, by = self.amount)
  end
end
