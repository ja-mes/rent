class AccountsTest < ActiveSupport::TestCase
  test "account should be valid" do
    assert accounts(:one).valid?
  end 
end
