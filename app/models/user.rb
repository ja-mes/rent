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

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create do
    Account.create(name: "Rental Income", balance: 0, user: self)
    Account.create(name: "Deposits", balance: 0, user: self)
    Account.create(name: "Checking", balance: 0, user: self)
    Account.create(name: "Undeposited Funds", balance: 0, user: self)
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
