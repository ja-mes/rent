class Reconciliation < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :user
  has_many :checks
  has_many :deposits

  def setup_trans(params)
    checks = Check.where(user: self.user, cleared: false).order('date DESC')
    deposits = Deposit.where(user: self.user, cleared: false).order('date DESC')

    if params[:deposits]
      deposits.each do |d|
        if params[:deposits].key?(d.id.to_s)
          d.update_attribute(:cleared, true)
          self.deposits << d
        end 
      end
    end

    if params[:checks]
      checks.each do |c|
        if params[:checks].key?(c.id.to_s)
          c.update_attribute(:cleared, true)
          self.checks << c
        end
      end
    end

    debugger
  end
end
