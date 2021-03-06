class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, only: [:show, :edit, :update, :archive, :edit_blank]
  before_action only: [:show, :edit, :update, :edit_blank] do
    require_same_user(@customer)
  end

  def index
    @customers = Customer.grab_all(current_user, params[:display]).paginate(page: params[:page])
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
    @customer = Customer.new
  end

  def create
    @properties = current_user.vacant_properties
    @customer = current_user.customers.build(customer_params)

    if @customer.save
      if @customer.customer_type == "tenant" && @customer.should_charge_deposit
        @customer.enter_rent params[:customer][:deposit], "Security Deposits", current_user.security_deposits_account.id
      end

      flash[:success] = "Customer successfully created"
      redirect_to customer_path(@customer)
    else
      if @customer.customer_type == "blank" then render 'blank' else render 'new' end
    end
  end

  def show
    @transactions = @customer.grab_trans(params[:display]).paginate(page: params[:page])
  end

  def edit
    if @customer.customer_type == "blank"
      render 'edit_blank'
    else
      @properties = current_user.rentable_properties
    end
  end

  def edit_blank
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
    params.require(:customer).permit(:first_name, :last_name, :middle_name, :company_name, :phone, :alt_phone, :property_id, :due_date, :rent, :customer_type, :should_charge_rent, :should_charge_deposit)
  end

  def note_params
    params.require(:note).permit(:content)
  end

  def set_customer
    @customer = Customer.find(params[:id])
  end
end
