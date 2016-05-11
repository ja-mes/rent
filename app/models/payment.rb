class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :customer
  belongs_to :account
  belongs_to :deposit

  has_one :tran, as: :transactionable, dependent: :destroy
  has_one :account_tran, as: :account_transable, dependent: :destroy

  validates :user_id, presence: true
  validates :customer_id, presence: true
  validates :amount, presence: true, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true

  before_create do
    self.create_account_tran(user: self.user, date: self.date, amount: self.amount, memo: self.memo, account_id: self.account.id)
  end

  after_create do
    self.create_tran(user: self.user, customer: self.customer, date: self.date)
    self.customer.increment!(:balance, by = -self.amount)
  end

  after_update do
    self.tran.update_attributes(customer: self.customer, date: self.date)
    self.account_tran.update_attributes(date: self.date, amount: self.amount, memo: self.memo)
  end

  after_destroy do
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
