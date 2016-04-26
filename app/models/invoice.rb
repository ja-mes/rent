class Invoice < ActiveRecord::Base
  attr_accessor :skip_tran_validation

  belongs_to :user
  belongs_to :customer
  has_one :tran, as: :transactionable, dependent: :destroy

  # invoice trans
  has_many :invoice_trans, dependent: :destroy, inverse_of: :invoice
  validates_presence_of :invoice_trans, unless: :skip_tran_validation
  accepts_nested_attributes_for :invoice_trans, allow_destroy: :true

  # invoice validations
  validates :user_id, presence: true
  validates :customer_id, presence: true
  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true

  after_create do
    self.create_tran(user: self.user, customer: self.customer, date: self.date)
    self.customer.increment!(:balance, by = self.amount)
  end

  after_update do
    self.tran.update_attributes(customer: self.customer, date: self.date)
  end

  after_destroy do
    self.customer.increment!(:balance, by = -self.amount)
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
end
