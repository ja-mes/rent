class RegisterController < ApplicationController
  before_action :authenticate_user!

  def index
    @trans = current_user.checks
    @balance = Account.find_by(user: current_user, name: "Checking").balance
  end
end
