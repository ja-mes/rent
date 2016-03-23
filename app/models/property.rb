class Property < ActiveRecord::Base
  validates :address, presence: true
  validates :state, presence: true, length: { is: 2 }
  validates :city, presence: true
  validates :zip, presence: true
  validates :rent, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :deposit, presence: true, numericality: { greater_than_or_equal_to: 0 }
  before_save :upcase_state

  def upcase_state
    self.state.upcase
  end
end
