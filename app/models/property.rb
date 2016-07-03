class Property < ApplicationRecord
  belongs_to :user
  has_many :customers
  has_many :account_trans

  validates :user_id, presence: true
  validates :address, presence: true
  validates_uniqueness_of :address
  validates :state, length: { is: 2 }, allow_blank: true
  validates :rent, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
  validates :deposit, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
  before_save :upcase_state, if: :state

  def upcase_state
    self.state = self.state.upcase
  end

  def full_address
    only_address = self.city.blank? && self.state.blank? && self.zip.blank?
    "#{self.address}#{',' unless only_address} #{self.city} #{self.state} #{self.zip}"
  end

  def self.create_all_properties_property(user_id)
    self.create(user_id: user_id, address: "All Properties", internal: true)
  end
end
