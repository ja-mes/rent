require 'test_helper'

class RegisterTest < ActiveSupport::TestCase
  def setup
    @register = registers(:one)
  end

  test "should be valid" do
    assert @register.valid?
  end

  test "user_id should be present" do
    @register.user = nil
    assert_not @register.valid?
  end

  test "balance should be present" do
    @register.balance = nil
    assert_not @register.valid?
  end

  test "name should be present" do
    @register.name = "  "
    assert_not @register.valid?
  end
end
