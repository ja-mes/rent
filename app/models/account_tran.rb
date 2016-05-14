class AccountTran < ActiveRecord::Base
  belongs_to :user
  belongs_to :account
  belongs_to :property
  belongs_to :account_transable, polymorphic: true

  validates :user_id, presence: true
  validates_numericality_of :amount
  validates :date, presence: true

  def self.calculate_total(account)
    total = 0

    inc_accounts = ["Income", "Other Current Assets", "Other Income"]
    dec_accounts = ["Expenses"]

    dec_account_trans = ["Check", "Deposit"]
    inc_account_trans = ["Payment", "Invoice"]

    AccountTran.find_each do |t|
      # deposit discrepancies should be incremented for deposits
      if account.name == "Deposit Discrepancies" && t.account_transable_type == "Deposit"
        total += t.amount
      elsif inc_accounts.include? account.account_type 
        if inc_account_trans.include? t.account_transable_type
          total += t.amount
        elsif dec_account_trans.include? t.account_transable_type
          total -= t.amount
        end
      elsif dec_accounts.include? account.account_type
        if inc_account_trans.include? t.account_transable_type
          total -= t.amount
        elsif dec_account_trans.include? t.account_transable_type
          total += t.amount
        end
      end
    end

    total
  end

  def self.calculate_property_total
    total = 0

    AccountTran.find_each do |t|
      if t.account_transable_type == "Invoice" 
        total += t.amount
      elsif t.account_transable_type == "Check"
        total -= t.amount
      end
    end

    total
  end

  def self.date_range(from, to)
    if from && to 
      from = Date.new from['date(1i)'].to_i, from['date(2i)'].to_i, from['date(3i)'].to_i
      to = Date.new to['date(1i)'].to_i, to['date(2i)'].to_i, to['date(3i)'].to_i
      AccountTran.where(date: from..to)
    else
      AccountTran.where(date: 1.month.ago..Date.today)
    end

  end
end
