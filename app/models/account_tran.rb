class AccountTran < ApplicationRecord
  belongs_to :user
  belongs_to :account
  belongs_to :property
  belongs_to :account_transable, polymorphic: true

  validates :user_id, presence: true
  validates_numericality_of :amount
  validates :date, presence: true
  validates :account, presence: true


  def self.calculate_total(account)
    total = 0

    total = AccountTran.sum(:amount)
    total *= -1 unless total == 0 || account.account_type.inc

    total
  end

  def self.calculate_property_total
    AccountTran.sum(:amount)
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
