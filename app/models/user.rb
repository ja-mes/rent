class User < ActiveRecord::Base
  has_many :properties
  has_many :customers
  has_many :payments
  has_many :invoices
  has_many :trans
  has_many :accounts
  has_many :account_types
  has_many :account_trans
  has_many :checks
  has_many :deposits
  has_many :vendors
  has_many :notes
  has_many :credits
  has_many :recurring_trans
  has_many :registers
  has_many :reconciliations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  
  after_create do
    checkbook = Register.create(user: self, name: "Checking", balance: 0)

    income = AccountType.create(user: self, name: "Income", inc: true)
    bank = AccountType.create(user: self, name: "Bank", inc: true)
    other_current_assets = AccountType.create(user: self, name: "Other Current Assets", inc: true)
    other_current_liabilities = AccountType.create(user: self, name: "Other Current Liabilities", inc: false)
    other_income = AccountType.create(user: self, name: "Other Income", inc: true)
    expenses = AccountType.create(user: self, name: "Expenses", inc: false)

    Account.create([
      {name: "Rental Income", account_type: income, balance: 0, required: true, user: self},       
      {name: "Checking", account_type: bank, balance: 0, required: true, user: self},
      {name: "Security Deposits", account_type: other_current_liabilities, balance: 0, required: true, user: self},
      {name: "Undeposited Funds", account_type: other_current_assets, balance: 0, required: true, user: self},
      {name: "Deposit Discrepancies", account_type: expenses, balance: 0, required: true, user: self},
      {name: "Reconciliation Discrepancies", account_type: expenses, balance: 0, required: true, user: self},
      {name: "Repairs and Maintenance", account_type: expenses, balance: 0, required: true, user: self},
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

  def after_database_authentication
    ChargeRentJob.perform_later self.id
    EnterRecurringTransJob.perform_later self.id
  end 


  # ACCOUNT METHODS

  # registers
  def checkbook
    Register.find_or_create_by(user: self, name: "Checking")
  end

  
  # account types
  def income_account_type
    AccountType.find_or_create_by(user: self, name: "Income", inc: true)
  end

  def bank_account_type
    AccountType.find_or_create_by(user: self, name: "Bank", inc: true)
  end

  def other_current_assets_account_type
    AccountType.find_or_create_by(user: self, name: "Other Current Assets", inc: true)
  end

  def other_current_liabilities_account_type
    AccountType.find_or_create_by(user: self, name: "Other Current Liabilities", inc: false)
  end

  def other_income_account_type
    AccountType.find_or_create_by(user: self, name: "Other Income", inc: true)
  end

  def expenses_account_type
    AccountType.find_or_create_by(user: self, name: "Expenses", inc: false)
  end

  
  # accounts
  def rental_income_account
    Account.create_with(account_type: income_account_type, balance: 0, required: true, user: self).find_or_create_by(name: "Rental Income")
  end

  def security_deposits_account
    Account.find_or_create_by(name: "Security Deposits", account_type: other_current_liabilities_account_type, balance: 0, required: true, user: self)
  end

  def undeposited_funds_account
    Account.create_with(account_type: other_current_assets_account_type, balance: 0, required: true, user: self).find_or_create_by(name: "Undeposited Funds")
  end

  def deposit_discrepancies_account
    Account.find_or_create_by(name: "Deposit Discrepancies", account_type: expenses_account_type, balance: 0, required: true, user: self)
  end

  def reconciliaton_discrepancies_account
    Account.find_or_create_by(name: "Reconciliation Discrepancies", account_type: expenses_account_type, balance: 0, required: true, user: self)
  end

  def repairs_and_maintenance_account
    Account.find_or_create_by(name: "Repairs and Maintenance", account_type: expenses_account_type, balance: 0, required: true, user: self)
  end
end
