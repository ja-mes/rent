class InvoiceTest < ActiveSupport::TestCase
  def setup
    @invoice = invoices(:one)
  end

  test "invoice should be valid" do
    assert @invoice.valid?
  end

  test 'user should be present' do
    @invoice.user = nil
    assert_not @invoice.valid?
  end

  test 'customer should be present' do
    @invoice.customer = nil
    assert_not @invoice.valid?
  end

  test 'amount should be present' do
    @invoice.amount = nil
    assert_not @invoice.valid?
  end

  test 'amount should not be negative' do
    @invoice.amount = -2.25
    assert_not @invoice.valid?
  end

  test 'amount should have a maximum of 2 decimals' do
    @invoice.amount = 2.222
    assert_not @invoice.valid?
  end

  test 'date should be present' do
    @invoice.date = nil
    assert_not @invoice.valid?
  end

  test "should be valid whether or not memo is present" do
    @invoice.memo = nil
    assert @invoice.valid?
  end


  test "after_create should work" do
    invoice = @invoice.dup
    assert_difference 'Tran.count' do
      invoice.save
      assert_equal invoice.customer.balance, invoice.amount
    end
  end

  test "after_update should work" do
    @invoice.date = "2016-08-07"
    @invoice.save
    assert_equal @invoice.tran.date, @invoice.date
  end

  test "after_destroy should work" do
    @invoice.destroy
    assert_equal @invoice.customer.balance, -@invoice.amount
  end

  test "calculate_balance should work" do
    @invoice.amount = 200
    assert_equal @invoice.customer.balance, -300
  end
end