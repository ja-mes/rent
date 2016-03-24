class CustomersController < ApplicationController
  before_action :authenticate_user!

  def index
    @customers = current_user.customers
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    @customer.full_name = "#{@customer.first_name} #{@customer.middle_name} #{@customer.last_name}"
    @customer.user = current_user

    if @customer.save
      flash[:success] = "Customer successfully created"
      redirect_to customer_path(@customer)
    else
      render 'new'
    end
  end

  def show
    @customer = Customer.find(params[:id])
  end

  private
  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :middle_name, :phone)
  end
end
