class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer
  before_action :set_payment, only: [:edit, :update, :destroy]
  before_action :require_same_user
  before_action :require_same_payment_user, only: [:edit, :update, :destroy]

  def index
    redirect_to @customer
  end

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.user = current_user

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
    @payment.destroy
    flash[:danger] = "Payment successfully deleted"
    redirect_to @customer
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

  def require_same_user
    if current_user != @customer.user
      flash[:danger] = "You are not authorized to do that"
      redirect_to root_path
    end
  end

  def require_same_payment_user
    if current_user != @payment.user
      flash[:danger] = "You are not authorized to do that"
      redirect_to root_path
    end
  end

  def payment_params
    params.require(:payment).permit(:customer_id, :amount, :date, :memo)
  end
end
