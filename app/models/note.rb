class Note < ActiveRecord::Base
  belongs_to :user
  belongs_to :customer

  validates :user_id, presence: true
  validates :content, presence: true, length: { minimum: 1 }
  validates :customer_id, presence: true
end
