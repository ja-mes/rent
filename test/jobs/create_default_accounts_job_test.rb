require 'test_helper'

class CreateDefaultAccountsJobTest < ActiveJob::TestCase
  test "should create default accounts for specified user" do
    CreateDefaultAccountsJob.perform_now users(:one).id
  end
end
