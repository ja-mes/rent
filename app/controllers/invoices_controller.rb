class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer
  before_action :require_same_user
  before_action :set_invoice, only: [:edit, :update, :destroy]
  before_action :require_same_invoice_user, only: [:edit, :update, :destroy]

  def index
    redirect_to @customer
  end

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.user = current_user

    if @invoice.save
      flash[:success] = "Invoice successfully saved"
      redirect_to @invoice.customer
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    old_amount = @invoice.amount
    old_customer = @invoice.customer

    if @invoice.update(invoice_params)
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
    params.require(:invoice).permit(:customer_id, :amount, :date, :memo)
  end

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def require_same_user
    if current_user != @customer.user
      flash[:danger] = "You are not authorized to do that"
      redirect_to root_path
    end
  end

  def require_same_invoice_user
    if current_user != @invoice.user
      flash[:danger] = "You are not authorized to do that"
      redirect_to root_path
    end
  end
end
