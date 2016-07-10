class Invoice < ApplicationRecord
  attr_accessor :skip_tran_validation

  # ASSOCIATIONS
  belongs_to :user
  belongs_to :customer
  has_one :tran, as: :transactionable, dependent: :destroy

  has_many :account_trans, as: :account_transable, dependent: :destroy
  validates_presence_of :account_trans, unless: :skip_tran_validation
  accepts_nested_attributes_for :account_trans, allow_destroy: :true

  # VALIDATIONS
  validates :user_id, presence: true
  validates :customer_id, presence: true
  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true
  validates :due_date, presence: true
  validate :totals_must_equal, unless: :skip_tran_validation

  # HOOKS
  after_create :create_invoice_tran, :inc_balance
  before_update :check_due_date

  after_update do
    self.tran.update_attributes(customer: self.customer, date: self.date) if self.tran
  end

  after_destroy do
    c = self.customer
    c.increment!(:balance, by = -self.amount) if c && self.charged
  end

  def totals_must_equal
    amount = 0
    self.account_trans.each do |tran|
      if tran.amount
        amount += tran.amount
      end
    end

    unless amount == self.amount
      errors.add(:base, "Invoice total must equal expenses total")
    end
  end

  def create_invoice_tran
    self.create_tran(user: self.user, customer: self.customer, date: self.date)
  end
  
  def inc_balance
    self.customer.increment!(:balance, by = self.amount) if self.due_date == Date.today
  end

  def check_due_date
    self.charged = false if self.due_date > Date.today
  end

  def calculate_balance(old_amount, old_customer)
    if old_customer == self.customer
      self.customer.increment(:balance, by = -old_amount)
      self.customer.increment!(:balance, by = self.amount)
    else
      old_customer.increment!(:balance, by = -old_amount)
      self.customer.increment!(:balance, by = self.amount)
    end
  end

  def self.enter_recurring_tran(tran)
    invoice = Invoice.new do |t|
      t.user_id = tran.user.id
      t.date = Date.today
      t.due_date = Date.today
      t.amount = tran.amount
      t.memo = tran.memo
      t.customer_id = tran.charge_id
    end
    invoice.skip_tran_validation = true
    invoice.save

    tran.account_trans.each do |act_tran|
      AccountTran.create do |t|
        t.user_id = tran.user_id
        t.account_transable = invoice
        t.account_id = act_tran["account_id"]
        t.amount = act_tran["amount"]
        t.memo = act_tran["memo"]
        t.property_id = act_tran["property_id"]
        t.date = invoice.date
      end
    end

    invoice
  end
end
