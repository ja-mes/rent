class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    income = [0, 0, 0, 0, 0, 0]

    trans = current_user.rental_income_account.account_trans
    0.upto(5) do |num|
      income[num] = trans.where(date: num.months.ago.beginning_of_month..num.months.ago.end_of_month).sum(:amount).to_f
    end

    @income = income.reverse
    @property_count = [current_user.properties.where(rented: true).count, current_user.properties.where(rented: false).count]

    accounts = current_user.accounts.includes(:account_trans).where(account_type: current_user.expenses_account_type)

    accounts.each do |a|
      print a.account_trans.where(date: Date.today).sum(:amount)
    end
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
