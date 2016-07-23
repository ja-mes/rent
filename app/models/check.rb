class Check < ApplicationRecord
  attr_accessor :skip_tran_validation

  # ASSOCIATIONS
  belongs_to :user
  belongs_to :reconciliation
  belongs_to :vendor
  has_one :tran, as: :transactionable, dependent: :destroy

  # VALIDATIONS
  validates :user_id, presence: true
  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true
  validate :totals_must_equal, unless: :skip_tran_validation

  # HOOKS
  before_update :update_if_cleared
  before_destroy :remove_cleared

  def totals_must_equal
    amount = 0
    self.account_trans.each do |tran|
      if tran.amount
        amount += tran.amount
      end
    end

    amount *= -1
    unless amount == self.amount
      errors.add(:base, "Check total must equal expenses total")
    end
  end

  def update_if_cleared
    if self.cleared?
      checkbook = self.user.checkbook

      checkbook.increment(:cleared_balance, self.amount_was)
      checkbook.decrement!(:cleared_balance, self.amount)
    end
  end

  def remove_cleared
    self.user.checkbook.increment!(:cleared_balance, self.amount) if self.cleared?
  end

  # account trans
  has_many :account_trans, as: :account_transable, dependent: :destroy
  validates_presence_of :account_trans, unless: :skip_tran_validation
  accepts_nested_attributes_for :account_trans, allow_destroy: :true

  after_create do
    self.create_tran(user: self.user, date: self.date)
    account = self.user.checkbook
    account.increment!(:balance, by = -self.amount)
  end

  after_update do
    self.tran.update_attributes(date: self.date)
  end

  after_destroy do
    account = self.user.checkbook
    account.increment!(:balance, by = self.amount)
  end

  def calculate_balance(old_amount)
    account = self.user.checkbook
    account.increment(:balance, by = old_amount)
    account.increment!(:balance, by = -self.amount)
  end

  def self.date_range(from, to)
    if from && to
      from = Date.new from['date(1i)'].to_i, from['date(2i)'].to_i, from['date(3i)'].to_i
      to = Date.new to['date(1i)'].to_i, to['date(2i)'].to_i, to['date(3i)'].to_i
      Check.where(date: from..to)
    else
      Check.where(date: 1.month.ago..Date.today)
    end
  end

  def self.enter_recurring_tran(tran)
    check = Check.new(user_id: tran.user.id, num: tran.num, date: Date.today, amount: tran.amount, memo: tran.memo, vendor_id: tran.charge_id)
    check.skip_tran_validation = true
    check.save

    tran.account_trans.each do |act_tran|
      account_tran = AccountTran.create(user_id: tran.user.id, account_transable: check, account_id: act_tran["account_id"], amount: act_tran["amount"], memo: act_tran["memo"], property_id: act_tran["property_id"], date: check.date)
    end

    check
  end

  def self.enter_reconciliation_discrepancy(user, amount)
    check = Check.new(user: user, num: "ADJ", date: Date.today, amount: amount, memo: "Reconcile adjustment", skip_tran_validation: true)

    discrepancies = user.reconciliaton_discrepancies_account
    account_tran = check.account_trans.new(user: user, account: discrepancies, amount: -amount, memo: "", property: nil, date: check.date)

    check.save
    account_tran.save

    check
  end
end
