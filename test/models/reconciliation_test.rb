require 'test_helper'

class ReconciliationTest < ActiveSupport::TestCase
  def setup
    @rec = reconciliations(:one)
  end

  test "should be valid" do
    assert @rec.valid?
  end
end
