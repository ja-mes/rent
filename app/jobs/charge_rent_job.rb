class ChargeRentJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Vendor.create(name: Faker::Name.name, user: User.first)
  end
end
