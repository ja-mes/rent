class Account < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :user
  belongs_to :account_type
  has_many :account_trans
  has_many :payments

  # VALIDATIONS
  validates :user_id, presence: true
  validates :name, presence: true
  validates :account_type, presence: true
  validate :not_required, on: :update

  def not_required
    self.errors.add(:base, "Cannot update default account") if self.required
  end
end
