class CustomersController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
    @customer = Customer.new
  end
end
