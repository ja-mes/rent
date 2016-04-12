class Customer < ActiveRecord::Base
  belongs_to :user
  belongs_to :property
  has_many :payments
  has_many :invoices

  validates :user_id, presence: true
  validates :property_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :full_name, presence: true
  validates_uniqueness_of :full_name

  def self.search(search, user)
    if search
      joins(:property).where('full_name LIKE ? OR balance LIKE ? OR properties.address LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%").where(user: user)
    else
      where(user: user)
    end
  end
end
