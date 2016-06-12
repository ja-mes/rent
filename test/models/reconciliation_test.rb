require 'test_helper'

class ReconciliationTest < ActiveSupport::TestCase
  def setup
    @rec = reconciliations(:one)
  end

  test "should be valid" do
    assert @rec.valid?
  end

  test "user should be present" do
    @rec.user = nil
    assert_not @rec.valid?
  end

  test "ending_balance should be present" do
    @rec.ending_balance = nil
    assert_not @rec.valid?
  end
end
