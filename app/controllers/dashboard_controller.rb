class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    income = [0, 0, 0, 0, 0, 0]

    # TODO move this to model
    Invoice.where(user: current_user, date: 6.months.ago..Date.today).find_each do |i|
      catch :done do
        5.downto(0) do |num|
          if i.date <= num.months.ago
            income[num] += i.amount
            throw :done
          end
        end
      end
    end

    Credit.where(user: current_user, date: 6.months.ago..Date.today).find_each do |i|
      catch :done do
        5.downto(0) do |num|
          if i.date <= num.months.ago
            income[num] -= i.amount
            throw :done
          end
        end
      end
    end

    Check.where(date: 6.months.ago..Date.today).find_each do |i|
      catch :done do
        5.downto(0) do |num|
          if i.date <= num.months.ago
            income[num] -= i.amount
            throw :done
          end
        end
      end
    end

    income.each_with_index { |val, i| income[i] = val.to_f }

    @income = income.reverse
    @property_count = [current_user.properties.where(rented: true).count, current_user.properties.where(rented: false).count]
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
