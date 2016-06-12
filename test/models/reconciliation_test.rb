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

  test "setup trans should get selected checks and deposits ready for reconcile" do
    checks = Check.where(user: users(:one), cleared: false)
    deposits = Deposit.where(user: users(:one), cleared: false)
    
    # {"date(2i)"=>"6", "date(3i)"=>"12", "date(1i)"=>"2016", "ending_balance"=>"30", "deposits"=>{"1"=>{"selected"=>"on"}}, "checks"=>{"4"=>{"selected"=>"on"}}}
    params = {date: "06/07/2016", ending_balance: 30, checks: {
      checks.first.id.to_s => {"selected"=>"on"}, checks.second.id.to_s => {"selected"=>"on"} 
    }, deposits: {
      deposits.first.id.to_s => {"selected"=>"on"}
    }}

    @rec.setup_trans(params, registers(:one).cleared_balance, checks, deposits)
     
    assert_equal @rec.checks.count, checks.count
    assert_equal @rec.deposits.count, deposits.count

    assert_equal @rec.cleared_balance, deposits.sum(:amount)- checks.sum(:amount)
  end

  test "create_discrepancies should create check if difference is < 0" do
    @rec.ending_balance = 500
    @rec.cleared_balance = 520

    check = nil
    assert_difference ["Check.count", "AccountTran.count", "Tran.count"] do
      check = @rec.create_discrepancies
    end

    assert_equal check.amount, 20
  end

  test "update register should update registers cleared balance" do
    @rec.cleared_balance = 300
    @rec.update_register

    assert_equal registers(:one).cleared_balance, 300
  end

  test "mark_trans_cleared" do
    @rec.checks = Check.where(user: users(:one), cleared: false)
    @rec.deposits = Deposit.where(user: users(:one), cleared: false)

    @rec.mark_trans_cleared

    @rec.checks.each {|c| assert c.reload.cleared }
    @rec.deposits.each {|d| assert d.reload.cleared }
  end
end
