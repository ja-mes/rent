class DashboardController < ApplicationController
  def index
  end

  def charge_rent
    ChargeRentJob.perform_later current_user.id

    respond_to do |f|
      f.html
      f.js
    end
  end
end
