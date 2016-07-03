class User < ApplicationRecord
  has_many :properties, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :trans, dependent: :destroy
  has_many :accounts, dependent: :destroy
  has_many :account_types, dependent: :destroy
  has_many :account_trans, dependent: :destroy
  has_many :checks, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :vendors, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :credits, dependent: :destroy
  has_many :recurring_trans, dependent: :destroy
  has_many :registers, dependent: :destroy
  has_many :reconciliations, dependent: :destroy

  after_create :create_default_accounts, on: :commit

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def create_default_accounts
    CreateDefaultAccountsJob.perform_later self.id
  end

  def create_default_accounts
    # checkbook
    checkbook = Register.find_or_create_by(user: self, name: "Checking", balance: 0)

    # account types
    income = AccountType.find_or_create_by(user: self, name: "Income", inc: true)
    bank = AccountType.find_or_create_by(user: self, name: "Bank", inc: true)
    other_current_assets = AccountType.find_or_create_by(user: self, name: "Other Current Assets", inc: true)
    other_current_liabilities = AccountType.find_or_create_by(user: self, name: "Other Current Liabilities", inc: false)
    other_income = AccountType.find_or_create_by(user: self, name: "Other Income", inc: true)
    expenses = AccountType.find_or_create_by(user: self, name: "Expenses", inc: false)

    # accounts
    Account.find_or_create_by(name: "Rental Income", account_type: income, required: true, user: self)
    Account.find_or_create_by(name: "Checking", account_type: bank, required: true, user: self)
    Account.find_or_create_by(name: "Security Deposits", account_type: other_current_liabilities, required: true, user: self)
    Account.find_or_create_by(name: "Undeposited Funds", account_type: other_current_assets, required: true, user: self)
    Account.find_or_create_by(name: "Deposit Discrepancies", account_type: expenses, required: true, user: self)
    Account.find_or_create_by(name: "Reconciliation Discrepancies", account_type: expenses, required: true, user: self)
    Account.find_or_create_by(name: "Repairs and Maintenance", account_type: expenses, required: true, user: self)

    # all properties property
    #Property.create_all_properties_property
  end

  def rentable_properties
    self.properties.where('id NOT IN (SELECT DISTINCT(property_id) FROM customers)')
  end

  def vacant_properties
    self.properties.where(rented: false)
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
    Account.create_with(account_type: income_account_type, balance: 0, required: true).find_or_create_by(name: "Rental Income", user: self)
  end

  def security_deposits_account
    Account.create_with(account_type: other_current_liabilities_account_type, balance: 0, required: true).find_or_create_by(name: "Security Deposits", user: self)
  end

  def undeposited_funds_account
    Account.create_with(account_type: other_current_assets_account_type, balance: 0, required: true).find_or_create_by(name: "Undeposited Funds", user: self)
  end

  def deposit_discrepancies_account
    Account.create_with(account_type: expenses_account_type, balance: 0, required: true).find_or_create_by(name: "Deposit Discrepancies", user: self)
  end

  def reconciliaton_discrepancies_account
    Account.create_with(account_type: expenses_account_type, balance: 0, required: true).find_or_create_by(name: "Reconciliation Discrepancies", user: self)
  end

  def repairs_and_maintenance_account
    Account.create_with(account_type: expenses_account_type, balance: 0, required: true).find_or_create_by(name: "Repairs and Maintenance", user: self)
  end
end
