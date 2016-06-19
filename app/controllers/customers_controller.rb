class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, only: [:show, :edit, :update, :archive]
  before_action only: [:show, :edit, :update] do
    require_same_user(@customer)
  end

  def index
    @customers = Customer.search(params[:search], params[:display], current_user).paginate(page: params[:page])
  end

  def new
    @customer = Customer.new(due_date: Date.today.beginning_of_month)
    @properties = current_user.vacant_properties

    if @properties.blank?
      flash[:danger] = "No properties avaiable to rent"
      redirect_to customers_path
    end
  end

  def blank
    @customer = Customer.new(customer_type: "blank")
  end

  def create
    @properties = current_user.vacant_properties
    @customer = current_user.customers.build(customer_params)

    if @customer.save
      unless @customer.customer_type == "blank"
        @customer.enter_rent params[:customer][:deposit], "Security Deposits", current_user.security_deposits_account.id
      end

      flash[:success] = "Customer successfully created"
      redirect_to customer_path(@customer)
    else
      if @customer.customer_type == "blank" then render 'blank' else render 'new' end
    end
  end

  def show
    @transactions = current_user.grab_trans(@customer).paginate(page: params[:page]).order(date: :desc)
  end

  def edit
    if @customer.customer_type == "blank" 
      render 'edit_blank'
    else
      @properties = current_user.rentable_properties
    end
  end

  def edit_blank
    @customer = Customer.find(params[:id])
  end

  def update
    @properties = current_user.vacant_properties

    if @customer.update(customer_params)
      flash[:success] = "Customer successfully updated"
      redirect_to edit_customer_path
    else
      if @customer.customer_type == "blank" then render 'edit_blank' else render 'edit' end
    end
  end

  def archive
    @customer.archive
    redirect_to @customer
    flash[:danger] = "Successfully moved out customer"
  end

  private
  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :middle_name, :phone, :alt_phone, :property_id, :due_date, :rent, :customer_type)
  end

  def note_params
    params.require(:note).permit(:content)
  end

  def set_customer
    @customer = Customer.find(params[:id])
  end
end
