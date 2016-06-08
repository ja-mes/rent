class Reconciliation < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :user
  has_many :checks
  has_many :deposits

  def setup_trans(params)
    checks = Check.where(user: self.user, cleared: false).order('date DESC')
    deposits = Deposit.where(user: self.user, cleared: false).order('date DESC')

    deposits.each do |c|
      if params[:deposits].key?(c.id.to_s)
      end 
    end
  end
end
