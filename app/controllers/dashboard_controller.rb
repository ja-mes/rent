class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    income = [0, 0, 0, 0, 0, 0]

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
