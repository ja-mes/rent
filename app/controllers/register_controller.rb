class RegisterController < ApplicationController
  before_action :authenticate_user!

  def index
    @trans = current_user.trans.where("transactionable_type = 'Deposit' OR transactionable_type = 'Check'").order('date DESC')
    @balance = current_user.checkbook.balance
  end
end
