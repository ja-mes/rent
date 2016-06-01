class ChargeRentJob < ActiveJob::Base
  queue_as :default

  def perform(user_id)
    today = Date.today
    user = User.find(user_id)

    user.customers.where('last_charged > ?', today.prev_month).find_each do |customer|
      num_months = (today.year * 12 + today.month) - (customer.last_charged.year * 12 + customer.last_charged.month)

      num_months.times do
        invoice = customer.invoices.build do |i|
          i.amount = customer.rent
          i.date = today
          i.memo = "Rent for #{Date::MONTHNAMES[today.month]} #{today.year}"
          i.user = user
        end
        invoice.skip_tran_validation = true
        invoice.save

        account_tran = AccountTran.create do |t|
          t.user = user
          t.account_id = Account.find_by(name: "Rental Income", user: customer.user).id
          t.account_transable = invoice
          t.amount = customer.rent
          t.memo = "Rent for #{Date::MONTHNAMES[today.month]} #{today.year}"
          t.property_id = customer.property.id
          t.date = invoice.date
        end

        customer.update_attribute(:charged_today, true)
        customer.update_attribute(:last_charged, today)
      end
    end
  end
end
