class Reconciliation < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :user
  has_many :checks
  has_many :deposits

  # HOOKS
  after_create :mark_trans_cleared

  def setup_trans(params)
    checks = Check.where(user: self.user, cleared: false).order('date DESC')
    deposits = Deposit.where(user: self.user, cleared: false).order('date DESC')

    if params[:deposits]
      deposits.each do |d|
        if params[:deposits].key?(d.id.to_s)
          self.deposits << d
        end 
      end
    end

    if params[:checks]
      checks.each do |c|
        if params[:checks].key?(c.id.to_s)
          self.checks << c
        end
      end
    end
  end

  def mark_trans_cleared
    self.checks.update_all(cleared: true)
    self.deposits.update_all(cleared: true)
  end
end
