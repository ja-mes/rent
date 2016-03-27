class Customer < ActiveRecord::Base
  belongs_to :user
  belongs_to :property
  validates :user_id, presence: true
  validates :property_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :full_name, presence: true
  validates_uniqueness_of :full_name
end
