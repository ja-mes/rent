class TestJob
  @queue = :default

  def self.perform
    Vendor.create(name: Faker::Name.name, user: User.first)
  end
end
