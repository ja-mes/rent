class CreditsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer
  before_action :set_credit, only: [:edit, :update, :destroy]

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
    if @credit.update(credit_params)
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
    params.require(:credit).permit(:date, :customer_id, :amount, :memo)
  end

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def set_credit
    @credit = Credit.find(params[:id])
  end
end
