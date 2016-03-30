class PaymentTest < ActiveSupport::TestCase
  def setup
    @payment = payments(:one)
  end

  test "payment should be valid" do
    assert @payment.valid?
  end

  test "user should be present" do
    @payment.user = nil
    assert_not @payment.valid?
  end

  test "customer should be present" do
    @payment.customer = nil
    assert_not @payment.valid?
  end

  test "amount should be present" do
    @payment.amount = nil
    assert_not @payment.valid?
  end

  test "amount should not be negative" do
    @payment.amount = -5.23
    assert_not @payment.valid?
  end

  test "date should be present" do
    @payment.date = nil
    assert_not @payment.valid?
  end
end
