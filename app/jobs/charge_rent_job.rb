class ChargeRentJob < ActiveJob::Base
  queue_as :default

  def perform(user_id)
    today = Date.today
    user = User.find(user_id)

    debugger
    user.customers.where('last_charged <= ? AND active = true', today.prev_month).find_each do |customer|
      debugger
      num_months = (today.year * 12 + today.month) - (customer.last_charged.year * 12 + customer.last_charged.month)

      num_months.times do
        customer.enter_rent
        customer.update_attribute(:last_charged, today)
      end
    end
  end
end
