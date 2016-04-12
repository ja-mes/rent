class User < ActiveRecord::Base
  has_many :properties
  has_many :customers
  has_many :payments
  has_many :invoices
  has_many :trans

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def vacant_properties
    self.properties.where('id NOT IN (SELECT DISTINCT(property_id) FROM customers)')
  end

  def grab_trans(customer)
    self.trans.where(customer: customer)
  end
end
