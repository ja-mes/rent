class MyJob
  @queue = :default

  def self.perform
    2.times do
      Vendor.create(name: Faker::Name.name, user: User.first)
    end
  end
end
