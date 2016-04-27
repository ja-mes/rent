class AccountsTest < ActiveSupport::TestCase
  test "account should be valid" do
    assert accounts(:one).valid?
  end 

  test "user_id should be present" do
    accounts(:one).user = nil
    assert_not accounts(:one).valid?
  end

  test "name should be present" do
    accounts(:one).name = "  "
    assert_not accounts(:one).valid?
  end

  test "balance should be present" do
    accounts(:one).balance = nil
    assert_not accounts(:one).valid?
  end
end
