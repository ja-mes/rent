class ChargeRentJob < ActiveJob::Base
  queue_as :default

  def perform(customer_id)
    customer = Customer.find(customer_id)

    invoice = customer.invoices.build do |i|
      i.amount = customer.rent
      i.date = today
      i.memo = "Rent for #{Date::MONTHNAMES[today.month]} #{today.year}"
      i.user = customer.user
    end
    invoice.skip_tran_validation = true
    invoice.save

    account_tran = AccountTran.create do |t|
      t.user = customer.user
      t.account_id = Account.find_by(name: "Rental Income", user: customer.user).id
      t.account_transable = invoice
      t.amount = customer.rent
      t.memo = "Rent for #{Date::MONTHNAMES[today.month]} #{today.year}"
      t.property_id = customer.property.id
      t.date = invoice.date
    end

    customer.toggle!(:charged_today)
  end
end
