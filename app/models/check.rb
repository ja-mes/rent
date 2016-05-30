class Check < ActiveRecord::Base
  attr_accessor :skip_tran_validation

  belongs_to :user
  validates :user_id, presence: true

  has_one :tran, as: :transactionable, dependent: :destroy

  belongs_to :vendor
  validates :vendor, presence: true

  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true
  validates :num, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :totals_must_equal, unless: :skip_tran_validation

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

  # account trans
  has_many :account_trans, as: :account_transable, dependent: :destroy
  validates_presence_of :account_trans, unless: :skip_tran_validation
  accepts_nested_attributes_for :account_trans, allow_destroy: :true

  after_create do
    self.create_tran(user: self.user, date: self.date)
    account = Account.find_by(user: self.user, name: "Checking")
    account.increment!(:balance, by = -self.amount)
  end

  after_update do
    self.tran.update_attributes(date: self.date)
  end

  after_destroy do
    account = Account.find_by(user: self.user, name: "Checking")
    account.increment!(:balance, by = self.amount)
  end

  def calculate_balance(old_amount)
    account = Account.find_by(user: self.user, name: "Checking")
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
    check = Check.new do |t|
      t.user_id = tran.user.id
      t.num = tran.num
      t.date = Date.today
      t.amount = tran.amount
      t.memo = tran.memo
      t.vendor_id = tran.charge_id
    end
    check.skip_tran_validation = true
    check.save

    tran.account_trans.each do |act_tran|
      account_tran = AccountTran.create do |t|
        t.user_id = tran.user.id
        t.account_transable = check
        t.account_id = act_tran["account_id"]
        t.amount = act_tran["amount"]
        t.memo = act_tran["memo"]
        t.property_id = act_tran["property_id"]
        t.date = check.date
      end
    end
  end
end

