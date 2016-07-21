class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    income = [0, 0, 0, 0, 0, 0]

    # TODO move this to model
    Invoice.where(date: 6.months.ago..Date.today).limit(3).find_each do |i|
      0.upto(6) do |num|
        if i.date <= num.months.ago
          income[num] += i.amount.to_f
        end
      end
    end

    Check.where(date: 6.months.ago..Date.today).find_each do |i|
      1.upto(6) do |num|
        if i.date <= num.months.ago
          income[num] -= i.amount.to_f
        end
      end
    end

    @income = income.reverse
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
