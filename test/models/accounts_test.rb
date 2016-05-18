class AccountsTest < ActiveSupport::TestCase
  def setup
    @account = accounts(:one)
  end
  test "account should be valid" do
    assert @account.valid?
  end 

  test "user_id should be present" do
    @account.user = nil
    assert_not @account.valid?
  end

  test "name should be present" do
    @account.name = "  "
    assert_not @account.valid?
  end

  test "balance should be present" do
    @account.balance = nil
    assert_not @account.valid?
  end

  test "should not be able to updated required accounts" do
    first_name = @account.name

    @account.required = true
    @account.name = "foobar"
    @account.save

    @account.reload
    assert_equal first_name, @account.name
  end
end
