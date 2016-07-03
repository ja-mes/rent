class Property < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :user
  has_many :customers
  has_many :account_trans

  # VALIDATIONS
  validates :user_id, presence: true
  validates :address, presence: true
  validates_uniqueness_of :address

  validates :city, presence: true, unless: :internal?
  validates :state, presence: true,  length: { is: 2 }, unless: :internal?
  validates :zip, presence: true, unless: :internal?

  validates :rent, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
  validates :deposit, numericality: { greater_than_or_equal_to: 0, allow_blank: true }

  # HOOKS
  before_save :upcase_state, if: :state

  def upcase_state
    self.state = self.state.upcase
  end

  def full_address
    only_address = self.city.blank? && self.state.blank? && self.zip.blank?

    if only_address
      "#{self.address}"
    else
      "#{self.address}, #{self.city} #{self.state} #{self.zip}"
    end
  end

  def self.create_all_properties_property(user_id)
    self.create(user_id: user_id, address: "All Properties", internal: true)
  end
end
