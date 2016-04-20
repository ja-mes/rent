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

property2 = Property.create do |i|
  i.user = user
  i.address = "200 Test St."
  i.state = "CA"
  i.city = "Elk"
  i.zip = "12345"
  i.rent = 200
  i.deposit = 50
  i.rented = true
end

property3 = Property.create do |i|
  i.user = user
  i.address = "300 Test St."
  i.state = "AL"
  i.city = "Foo"
  i.zip = "35976"
  i.rent = 600
  i.deposit = 800
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

customer3 = Customer.create do |i|
  i.user = user
  i.property = property2
  i.first_name = "First2"
  i.middle_name = "Middle2"
  i.last_name = "Last2"
  i.phone = "(256)456-7891"
  i.alt_phone = "(256)123-456"
  i.balance = 0
  i.charged_today = false
  i.rent = 200
  i.due_date = "10"
  i.active = true
end

customer4 = Customer.create do |i|
  i.user = user
  i.property = property3
  i.first_name = "First3"
  i.middle_name = "Middle3"
  i.last_name = "Last3"
  i.phone = "(256)456-7891"
  i.alt_phone = "(256)123-456"
  i.balance = 0
  i.charged_today = false
  i.rent = 600
  i.due_date = "1"
  i.active = true
end

customer5 = Customer.create do |i|
  i.user = user
  i.property = property4
  i.first_name = "First4"
  i.middle_name = "Middle4"
  i.last_name = "Last4"
  i.phone = "(256)456-7891"
  i.alt_phone = "(256)123-456"
  i.balance = 0
  i.charged_today = false
  i.rent = 600
  i.due_date = "1"
  i.active = true
end

customer6 = Customer.create do |i|
  i.user = user
  i.property = property5
  i.first_name = "First5"
  i.middle_name = "Middle5"
  i.last_name = "Last5"
  i.phone = "(256)456-7891"
  i.alt_phone = "(256)123-456"
  i.balance = 0
  i.charged_today = false
  i.rent = 600
  i.due_date = "1"
  i.active = true
end
