class Vendor < ApplicationRecord
  belongs_to :user
  has_many :checks

  validates :user_id, presence: true
  validates :name, presence: true
end
