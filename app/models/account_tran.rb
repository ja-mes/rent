class AccountTran < ActiveRecord::Base
  belongs_to :user
  belongs_to :accounts
  belongs_to :properties
  belongs_to :account_transable, polymorphic: true

  validates :user_id, presence: true
  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true
  validates :inc, inclusion: [true, false]

  def self.calculate_total(account)
    total = 0

    AccountTran.all.each do |t|
      if account.account_type == "Income" || account.account_type == "Other Current Assets"
        if t.inc?
          total += t.amount
        else
          total -= t.amount
        end
      elsif account.account_type == "Expense"
        if t.inc?
          total -= t.amount
        else
          total += t.amount
        end
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
