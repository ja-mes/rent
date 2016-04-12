class Customer < ActiveRecord::Base
  belongs_to :user
  belongs_to :property
  has_many :payments
  has_many :invoices
  has_many :trans

  validates :user_id, presence: true
  validates :property_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates_uniqueness_of :full_name

  def self.search(search, user)
    if search
      joins(:property)
      .where('first_name LIKE ? OR middle_name LIKE ? OR last_name LIKE ? OR balance LIKE ? OR properties.address LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
      .where(user: user)
    else
      where(user: user)
    end
  end

  def full_name
    "#{self.first_name} #{self.middle_name} #{self.last_name}"
  end
end
