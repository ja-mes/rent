class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer
  before_action :set_payment, only: [:edit, :update, :destroy]

  before_action do
    require_same_user(@customer)
  end
  before_action only: [:edit, :update, :destroy] do
    require_same_user(@payment)
  end


  def index
    redirect_to @customer
  end

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.user = current_user
    @payment.account = Account.find_by(user: current_user, name: "Undeposited Funds")

    if @payment.save
      flash[:success] = "Payment successfully created"
      redirect_to @payment.customer
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    old_amount = @payment.amount
    old_customer = @payment.customer

    if @payment.update(payment_params)
      @payment.calculate_balance old_amount, old_customer

      flash[:success] = 'Payment successfully updated'
      redirect_to edit_customer_payment_path(@payment.customer, @payment)
    else
      render 'edit'
    end
  end

  def destroy
    if @payment.deposit
      flash[:danger] = 'Payment must be removed from deposit before it can be deleted'
      render 'edit'
    else
      @payment.destroy
      flash[:danger] = "Payment successfully deleted"
      redirect_to @customer
    end
  end

  def show
    redirect_to edit_customer_payment_path(@customer, params[:id])
  end


  private
  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:customer_id, :amount, :date, :memo)
  end
end
