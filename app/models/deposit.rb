class Deposit < ActiveRecord::Base
  belongs_to :user
  belongs_to :reconciliation

  has_one :tran, as: :transactionable, dependent: :destroy

  has_many :payments
  validates_presence_of :payments, unless: :internal
  has_many :account_trans, as: :account_transable, dependent: :destroy

  validates :user_id, presence: true
  validates :date, presence: true
  validates_numericality_of :amount
  validates_numericality_of :discrepancies, allow_blank: true

  after_create :create_deposit_trans
  after_update :update_tran
  after_destroy :remove_amount
  before_update :update_if_cleared

  def update_if_cleared
    if self.cleared?
      checkbook = self.user.checkbook

      checkbook.decrement(:cleared_balance, self.amount_was)
      checkbook.increment!(:cleared_balance, self.amount)
    end
  end

  def remove_cleared
    self.user.checkbook.increment!(:cleared_balance, self.amount) if self.cleared?
  end

  def create_discrepancies
    if self.discrepancies
      discrepancies_account = self.user.deposit_discrepancies_account
      self.account_trans.create(user: self.user, date: self.date, amount: self.discrepancies, account_id: discrepancies_account.id)
    end
  end

  def create_deposit_trans
    self.create_tran(user: self.user, date: self.date)

    account = nil
    if self.internal
      account = self.user.reconciliaton_discrepancies_account
    else
      account = self.user.undeposited_funds_account
    end

    tran_amount = self.discrepancies ? self.amount - self.discrepancies : self.amount
    tran_amount *= -1 # deposits are type dec
    self.account_trans.create(user: self.user, date: self.date, amount: tran_amount, account_id: account.id)

    # XXX: discrepancies account_tran MUST be created after the deposit account_tran
    self.create_discrepancies
  end

  # deposit trans must be updated manually
  def update_tran 
    self.tran.update_attributes(date: self.date)

    if self.account_trans.count == 1
      tran_amount = self.discrepancies ? self.amount - self.discrepancies : self.amount
      tran_amount *= -1
      self.account_trans.first.update_attributes(date: self.date, amount: tran_amount)

      self.create_discrepancies
    else
      tran_amount = self.discrepancies ? self.amount - self.discrepancies : self.amount
      tran_amount *= -1
      self.account_trans.first.update_attributes(date: self.date, amount: tran_amount)
      if self.discrepancies 
        self.account_trans.second.update_attributes(date: self.date, amount: self.discrepancies)
      else
        self.account_trans.second.destroy
      end
    end
  end

  def remove_amount
    account = self.user.checkbook
    account.increment!(:balance, by = -self.amount)
  end

  def calculate_balance(old_amount = nil)
    account = self.user.checkbook
    account.increment(:balance, by = -old_amount) if old_amount
    account.increment!(:balance, by = self.amount)
  end

  def self.enter_reconciliation_discrepancy(user, amount)
    deposit = Deposit.create(user: user, date: Date.today, amount: amount, internal: true)
    deposit.calculate_balance

    deposit
  end
end
