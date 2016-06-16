class Property < ActiveRecord::Base
  belongs_to :user
  has_many :customers
  has_many :account_trans

  validates :user_id, presence: true
  validates :address, presence: true
  validates_uniqueness_of :address
  validates :state, presence: true, length: { is: 2 }
  validates :city, presence: true
  validates :zip, presence: true
  validates :rent, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :deposit, presence: true, numericality: { greater_than_or_equal_to: 0 }
  before_save :upcase_state

  def upcase_state
    self.state = self.state.upcase
  end

  def full_address
    "#{self.address}, #{self.city}, #{self.state} #{self.zip}"
  end

  def self.search(search, user)
    if search
      where('address ilike ? OR city ilike ? OR state ilike ? or zip ilike ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%").where(user: user)
    else
      where(user: user)
    end
  end
end
