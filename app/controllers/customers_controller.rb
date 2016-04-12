class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:show, :edit, :update]

  def index
    @customers = Customer.search(params[:search], current_user).paginate(page: params[:page], per_page: 5)
  end

  def new
    @customer = Customer.new
    @properties = current_user.vacant_properties

    if @properties.empty?
      flash[:danger] = "No properties avaiable to rent"
      redirect_to customers_path
    end
  end

  def create
    @properties = current_user.vacant_properties
    @customer = current_user.customers.build(customer_params)

    if @customer.save
      flash[:success] = "Customer successfully created"
      redirect_to customer_path(@customer)
    else
      render 'new'
    end
  end

  def show
    @transactions = current_user.grab_trans(@customer).paginate(page: params[:page]).order(date: :desc)
  end

  def edit
    @properties = current_user.vacant_properties
  end

  def update
    @properties = current_user.vacant_properties

    if @customer.update(customer_params)
      flash[:success] = "Customer successfully updated"
      redirect_to edit_customer_path
    else
      render 'edit'
    end
  end

  private
  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :middle_name, :phone, :alt_phone, :property_id)
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
