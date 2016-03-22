class Property < ActiveRecord::Base
  validates :address, presence: true
  validates :state, presence: true, length: { is: 2 }
  validates :city, presence: true
  validates :zip, presence: true
  before_save :upcase_state

  def upcase_state
    self.state.upcase
  end
end
