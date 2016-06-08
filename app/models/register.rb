class Register < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :balance, presence: true
  validates :name, presence: true
end
