class Customer < ActiveRecord::Base
  belongs_to :user
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :full_name, presence: true
  validates_uniqueness_of :full_name
end
