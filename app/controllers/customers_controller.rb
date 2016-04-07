class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:show, :edit, :update]

  def index
    @customers = current_user.customers
  end

  def new
    @customer = Customer.new
    @properties = current_user.properties.where('id NOT IN (SELECT DISTINCT(property_id) FROM customers)')

    if @properties.empty?
      flash[:danger] = "No properties avaiable to rent"
      redirect_to customers_path
    end
  end

  def create
    @customer = Customer.new(customer_params)
    @properties = current_user.properties.where('id NOT IN (SELECT DISTINCT(property_id) FROM customers)')
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
    @transactions = Transaction.where(user: current_user, customer: @customer).paginate(page: params[:page]).order(date: :desc)
  end

  def edit
    @properties = current_user.properties.where('id NOT IN (SELECT DISTINCT(property_id) FROM customers)')
  end

  def update
    @properties = current_user.properties.where('id NOT IN (SELECT DISTINCT(property_id) FROM customers)')

    @customer.assign_attributes(customer_params)
    @customer.full_name = "#{@customer.first_name} #{@customer.middle_name} #{@customer.last_name}"

    if @customer.save
      flash[:success] = "Customer successfully updated"
      redirect_to edit_customer_path
    else
      render 'edit'
    end
  end

  private
  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :middle_name, :phone, :property_id)
  end

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def require_same_user
    if current_user != @customer.user
      flash[:danger] = "You are not authorized to do that"
      redirect_to root_path
    end
  end
end
