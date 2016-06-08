class Reconciliation < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :user
  has_many :checks
  has_many :deposits

  def setup_trans(params)
    checks = Check.where(user: self.user, cleared: false).order('date DESC')
    deposits = Deposit.where(user: self.user, cleared: false).order('date DESC')

    deposits.each do |d|
      if params[:deposits].key?(d.id.to_s)
        self.deposits << d
      end 
    end

    checks.each do |c|
      if params[:checks].key?(c.id.to_s)
        self.checks << c
      end
    end
  end
end
