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

  test 'date should be present' do
    @invoice.date = nil
    assert_not @invoice.valid?
  end

  test "should be valid whether or not memo is present" do
    @invoice.memo = nil
    assert @invoice.valid?
  end
end
