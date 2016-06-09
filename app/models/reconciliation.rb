class Reconciliation < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :user
  has_many :checks
  has_many :deposits

  # HOOKS
  after_create :mark_trans_cleared

  def prepare(params)
    checks = Check.where(user: self.user, cleared: false).order('date DESC')
    deposits = Deposit.where(user: self.user, cleared: false).order('date DESC')
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

    if cleared_balance != params[:ending_balance].to_d
    end
  end

  def mark_trans_cleared
    self.checks.update_all(cleared: true)
    self.deposits.update_all(cleared: true)
  end
end
