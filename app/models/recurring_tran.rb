class RecurringTran < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, presence: true
  validates :amount, presence: true
  validates :due_date, presence: true
  validates :type, presence: true
end
