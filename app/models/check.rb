class Check < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true

  has_one :tran, as: :transactionable, dependent: :destroy

  belongs_to :vendor
  validates :vendor, presence: true

  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true
  validates :num, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :totals_must_equal

  def totals_must_equal
    amount = 0
    self.account_trans.each do |tran|
      amount += tran.amount
    end

    unless amount == self.amount
      errors.add(:base, "Check total must equal expenses total")
    end
  end

  # account trans
  has_many :account_trans, as: :account_transable, dependent: :destroy
  validates_presence_of :account_trans
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
end

