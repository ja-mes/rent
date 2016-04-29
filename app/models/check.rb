class Check < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true
  validates :num, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # account trans
  has_many :account_trans, as: :account_transable, dependent: :destroy
  validates_presence_of :account_trans
  accepts_nested_attributes_for :account_trans, allow_destroy: :true

  after_create do
    account = Account.find_by(user: self.user, name: "Checking")
    account.increment!(:balance, by = -self.amount)
  end

  after_destroy do
    account = Account.find_by(user: self.user, name: "Checking")
    account.increment!(:balance, by = self.amount)
  end

  def calculate_balance(old_amount)
    account = Account.find_by(user: self.user, name: "Checking")
    account.increment(:balance, by = old_amount)
    account.increment!(:balance, by = -self.amount)
  end
end

