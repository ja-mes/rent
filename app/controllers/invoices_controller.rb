class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer
  before_action :set_invoice, only: [:edit, :update, :destroy]
  before_action :set_vars, except: [:index, :show, :destroy]

  before_action do
    require_same_user(@customer)
  end
  before_action only: [:edit, :update, :destroy] do
    require_same_user(@invoice)
  end

  layout "fluid"

  def index
    redirect_to @customer
  end

  def new
    @invoice = Invoice.new
    @invoice.account_trans.build
  end

  def create
    @invoice = current_user.invoices.new(invoice_params)

    @invoice.account_trans.each do |tran|
      tran.user = current_user
      tran.date = @invoice.date
    end

    if @invoice.save
      flash[:success] = "Invoice successfully saved"
      redirect_to edit_customer_invoice_path(@invoice.customer, @invoice)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    old_amount = @invoice.amount
    old_customer = @invoice.customer

    @invoice.attributes = invoice_params

    @invoice.account_trans.each do |tran|
      tran.user = current_user
      tran.date = @invoice.date
    end

    if @invoice.save
      @invoice.calculate_balance old_amount, old_customer
      flash[:success] = "Invoice successfully updated"
      redirect_to edit_customer_invoice_path(@invoice.customer, @invoice)
    else
      render 'edit'
    end
  end

  def destroy
    @invoice.destroy

    flash[:danger] = "Invoice successfully deleted"
    redirect_to @customer
  end

  def show
    redirect_to edit_customer_invoice_path(@customer, params[:id])
  end

  private
  def invoice_params
    params.require(:invoice).permit(:customer_id, :amount, :date, :due_date, :memo, account_trans_attributes: [:id, :account_id, :property_id, :amount, :memo, :_destroy])
  end

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def set_vars
    @customers = Customer.where(user: current_user, active: true)
    @accounts = current_user.accounts
    @properties = current_user.properties
  end
end
