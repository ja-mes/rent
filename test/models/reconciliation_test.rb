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
      deposits.first.id.to_s => {"selected"=>"on"}, deposits.second.id.to_s => {"selected"=>"on"} 
    }}

    @rec.setup_trans(params, registers(:one).cleared_balance, checks, deposits)
  end
end
