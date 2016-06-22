ActiveRecord::Base.transaction do
  user = User.create!(email: "test@example.com", password: 'password', password_confirmation: 'password')

  100.times do
    property = Property.create!(user: user, address: Faker::Address.street_address, state: Faker::Address.state_abbr, city: Faker::Address.city, zip: Faker::Address.zip, rent: Faker::Commerce.price, deposit: Faker::Commerce.price)
    customer = Customer.create!(user: user, property: property, first_name: Faker::Name.first_name, middle_name: Faker::Name.first_name, last_name: Faker::Name.last_name, phone: Faker::PhoneNumber.cell_phone, alt_phone: Faker::PhoneNumber.phone_number, rent: 500, due_date: "1", active: true)

    5.times do
      invoice = Invoice.new(user: user, customer: customer, amount: Faker::Commerce.price, date: Date.today, memo: Faker::Lorem.sentence)
      invoice.skip_tran_validation = true
      invoice.save

      AccountTran.create!(user: user, amount: invoice.amount, memo: invoice.memo, account: user.rental_income_account, property: Property.order("RANDOM()").first, date: invoice.date, account_transable: invoice)
    end

    6.times do
      Payment.create!(user: user, customer: customer, method: "Cash", amount: Faker::Commerce.price, date: Date.today, memo: Faker::Lorem.sentence, account: user.undeposited_funds_account)
    end

  end
end
