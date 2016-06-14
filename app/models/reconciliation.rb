class Reconciliation < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :user
  has_many :checks
  has_many :deposits

  # VALIDATIONS
  validates :user_id, presence: true
  validates :ending_balance, presence: true

  # HOOKS
  before_save :create_discrepancies
  after_create :create_discrepancies, :update_register, :mark_trans_cleared
  before_destroy :remove_reconciliation_from_register
  after_destroy :mark_trans_uncleared

  def setup_trans(params, cleared_balance, checks, deposits)
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
        deposit = Deposit.enter_reconciliation_discrepancy(user, difference.abs)

        self.deposits << deposit
        self.cleared_balance += difference
        
        deposit
      elsif difference < 0
        check = Check.enter_reconciliation_discrepancy(user, difference.abs)

        self.checks << check
        self.cleared_balance += difference

        check
      end
    end
  end

  def update_register
    register = Register.find_by(user: self.user, name: "Checking")
    register.update_attribute(:cleared_balance, cleared_balance)
  end

  def remove_reconciliation_from_register
    register = Register.find_by(user: self.user, name: "Checking")
    amount = deposits.sum(:amount) - checks.sum(:amount)
    register.decrement!(:cleared_balance, amount)
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
