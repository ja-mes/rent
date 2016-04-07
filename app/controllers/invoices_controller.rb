class InvoicesController < ApplicationController
  before_action :set_customer

  def index
    redirect_to @customer
  end

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.customer = @customer
    @invoice.user = current_user

    if @invoice.save
      Transaction.create(transactionable: @invoice, user: current_user, customer: @customer, date: @invoice.date)
      flash[:success] = "Invoice successfully saved"
      redirect_to @customer
    else
      render 'new'
    end
  end

  def edit
    @invoice = Invoice.find(params[:id])
  end

  def update
    @invoice = Invoice.find(params[:id])
    if @invoice.update(invoice_params)
      flash[:success] = "Invoice successfully updated"
      redirect_to edit_customer_invoice_path
    else
      render 'edit'
    end
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
    flash[:danger] = "Invoice successfully deleted"
    redirect_to @customer
  end

  def show
    redirect_to edit_customer_invoice_path(@customer, params[:id])
  end

  private
  def invoice_params
    params.require(:invoice).permit(:amount, :date, :memo)
  end

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end
end
