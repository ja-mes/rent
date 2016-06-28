class Note < ApplicationRecord
  belongs_to :user
  belongs_to :customer

  validates :user_id, presence: true
  validates :customer_id, presence: true
  validates :content, presence: true, length: { minimum: 1 }
  validates :date, presence: true
end
