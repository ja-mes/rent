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

  test 'amount should have a maximum of 2 decimals' do
    @payment.amount = 2.222
    assert_not @payment.valid?
  end

  test "date should be present" do
    @payment.date = nil
    assert_not @payment.valid?
  end


  test "after_create should work" do
    payment = @payment.dup

    assert_difference 'Tran.count' do
      payment.save
      assert_equal payment.customer.balance, -payment.amount
    end
  end

  test "after_update should work" do
    @payment.date = "2016-08-07"
    @payment.save
    assert_equal @payment.tran.date, @payment.date
  end

  test "after_destroy should work" do
    @payment.destroy
    assert_equal @payment.customer.balance, @payment.amount
  end

  test "calculate_balance should work" do
    @payment.amount = 200
    @payment.calculate_balance(500)
    assert_equal @payment.customer.balance, 300
  end
end
