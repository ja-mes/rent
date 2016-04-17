user = User.new do |i|
  i.email = "test@example.com"
  i.password = 'password'
  i.password_confirmation = 'password'
end
user.save

property = Property.create do |i|
  i.user = user
  i.address = "100 Test St."
  i.state = "AL"
  i.city = "Boaz"
  i.zip = "35956"
  i.rent = 500
  i.deposit = 200
  i.rented = true
end

customer = Customer.create do |i|
  i.user = user
  i.property = property
  i.first_name = "First"
  i.middle_name = "Middle"
  i.last_name = "Last"
  i.phone = "(256)456-7891"
  i.alt_phone = "(256)123-456"
  i.balance = 0
  i.charged_today = false
  i.rent = 500
  i.due_date = "1"
  i.active = true
end

customer2 = Customer.create do |i|
  i.user = user
  i.property = property
  i.first_name = "Joe"
  i.middle_name = "Foo"
  i.last_name = "Blah"
  i.phone = "(256)456-7891"
  i.alt_phone = "(256)123-456"
  i.balance = 0
  i.charged_today = false
  i.rent = 200
  i.due_date = "2"
  i.active = false
end
