class CreditsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer
  before_action :set_credit, only: [:edit, :update, :destroy]
  before_action :set_vars, except: [:index, :show, :destroy]

  before_action do
    require_same_user(@customer)
  end

  before_action only: [:edit, :update, :destroy] do
    require_same_user(@credit)
  end

  def index
    redirect_to @customer
  end

  def new
    @credit = Credit.new
    @credit.account_trans.build
  end

  def create
    @credit = current_user.credits.new(credit_params)

    if @credit.save
      flash[:success] = "Credit successfully saved"
      redirect_to edit_customer_credit_path(@credit.customer, @credit)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    old_amount = @credit.amount
    old_customer = @credit.customer
     
    if @credit.update(credit_params)
      @credit.calculate_balance old_amount, old_customer
      flash[:success] = "Credit successfully updated"
      redirect_to edit_customer_credit_path(@credit.customer, @credit)
    else
      render 'edit'
    end
  end

  def destroy
    @credit.destroy

     flash[:danger] = "Credit successfully deleted"
     redirect_to @customer
  end

  private
  def credit_params
    params.require(:credit).permit(:date, :customer_id, :amount, :memo, account_trans_attributes: [:id, :account_id, :property_id, :amount, :memo, :_destroy])
  end

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def set_credit
    @credit = Credit.find(params[:id])
  end

  def set_vars
    @accounts = current_user.accounts
    @properties = current_user.properties
  end
end
