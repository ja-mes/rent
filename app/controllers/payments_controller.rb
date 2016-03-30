class PaymentsController < ApplicationController
  before_action :set_customer

  def new
  end

  private
  def set_customer
    @customer = Customer.find(params[:customer_id])
  end
end
