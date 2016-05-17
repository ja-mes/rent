require 'test_helper'

class AccountTypeTest < ActiveSupport::TestCase
  def setup
    @type = account_types(:income)
  end

  test "should be valid" do
    assert @type.valid?
  end

  test "user should be present" do
    @type.user = nil
    assert_not @type.valid?
  end

  test "name should be present" do
    @type.name = "   "
    assert_not @type.valid?
  end
end
