class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    income = [0, 0, 0, 0, 0, 0]

    trans = current_user.rental_income_account.account_trans
    0.upto(5) do |num|
      income[num] = trans.where(date: num.months.ago.beginning_of_month..num.months.ago.end_of_month).sum(:amount).to_f
    end

    @income = income.reverse.join(',')
    @income_months = 6.downto(1).map { |n| DateTime::MONTHNAMES.drop(1)[(Date.today.month - n) % 12] }.join(',')

    @property_count = [current_user.properties.where(rented: true).count, current_user.properties.where(rented: false).count].join(',')

    accounts = current_user.accounts.includes(:account_trans).where(account_type: current_user.expenses_account_type)

    accounts_hash = {}
    accounts.each do |a|
      name = a.name
      trans = a.account_trans.where(date: (Date.today - 30.days)..Date.today)
      trans.each do |t|
        if accounts_hash[name]
          accounts_hash[name] -= t.amount
        else
          accounts_hash[name] = -t.amount
        end
      end
    end


    accounts_top5 = accounts_hash.sort_by {|_key, value| -value}.take(5).to_h
    @accounts_data = accounts_top5.values.collect {|i| i.to_f}.join(',')
    @accounts_keys = accounts_top5.keys.take(5).join(',')
  end

  def charge_rent
    ChargeRentJob.perform_later current_user.id

    respond_to do |f|
      f.js
    end
  end

  def enter_recurring_trans
    EnterRecurringTransJob.perform_later current_user.id

    respond_to do |f|
      f.js
    end
  end
end
