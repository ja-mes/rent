class User < ActiveRecord::Base
  has_many :properties
  has_many :customers
  has_many :payments
  has_many :invoices
  has_many :trans
  has_many :accounts
  has_many :account_trans
  has_many :checks
  has_many :deposits
  has_many :vendors
  has_many :notes

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create do
    income = AccountType.create(user: self, name: "Income", inc: true)
    checking = AccountType.create(user: self, name: "Bank", inc: true)
    undeposited = AccountType.create(user: self, name: "Other Current Assets", inc: true)
    discrepancies = AccountType.create(user: self, name: "Other Income", inc: true)
    repairs = AccountType.create(user: self, name: "Expenses", inc: false)

    Account.create([
      {name: "Rental Income", account_type: income, balance: 0, required: true, user: self},       
      {name: "Checking", account_type: checking, balance: 0, required: true, user: self},
      {name: "Undeposited Funds", account_type: undeposited, balance: 0, required: true, user: self},
      {name: "Deposit Discrepancies", account_type: discrepancies, balance: 0, required: true, user: self},
      {name: "Repairs and Maintenance", account_type: repairs, balance: 0, required: true, user: self},
    ])
  end

  def rentable_properties
    self.properties.where('id NOT IN (SELECT DISTINCT(property_id) FROM customers)')
  end

  def vacant_properties
    self.properties.where(rented: false)
  end

  def grab_trans(customer)
    self.trans.where(customer: customer)
  end
end
