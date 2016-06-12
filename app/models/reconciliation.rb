class Reconciliation < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :user
  has_many :checks
  has_many :deposits

  # VALIDATIONS
  validates :user_id, presence: true
  validates :ending_balance, presence: true

  # HOOKS
  after_create :create_discrepancies, :mark_trans_cleared, :update_register
  after_destroy :mark_trans_uncleared

  def setup_trans(params)
    checks = Check.where(user: self.user, cleared: false)
    deposits = Deposit.where(user: self.user, cleared: false)
    register = Register.find_by(user: self.user, name: "Checking")

    cleared_balance = register.cleared_balance

    if params[:deposits]
      deposits.each do |d|
        if params[:deposits].key?(d.id.to_s)
          self.deposits << d
          cleared_balance += d.amount
        end 
      end
    end

    if params[:checks]
      checks.each do |c|
        if params[:checks].key?(c.id.to_s)
          self.checks << c
          cleared_balance -= c.amount
        end
      end
    end

    self.cleared_balance = cleared_balance
  end

  def create_discrepancies
    difference = ending_balance - cleared_balance

    unless difference == 0
      if difference > 0
        # enter deposit
      elsif difference < 0
        Check.enter_reconciliation_discrepancy(user, difference.abs)
      end
    end
  end

  def update_register
    register = Register.find_by(user: self.user, name: "Checking")
    register.update_attribute(:cleared_balance, cleared_balance)
  end

  def mark_trans_cleared
    self.checks.update_all(cleared: true)
    self.deposits.update_all(cleared: true)
  end

  def mark_trans_uncleared
    self.checks.update_all(cleared: false)
    self.deposits.update_all(cleared: false)
  end
end
