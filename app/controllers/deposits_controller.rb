class DepositsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_deposit, only: [:update, :edit, :destroy]
  before_action :require_same_user, only: [:update, :edit, :destroy]

  def index
    redirect_to new_deposit_path
  end

  def new
    @deposit = Deposit.new
    @account = Account.find_by(name: "Undeposited Funds", user: current_user)
    @payments = @account.payments.where(deposit: nil)
  end

  def create
    @deposit = current_user.deposits.new(deposit_params)
    @deposit.amount = 0
    @payments = Account.find_by(name: "Undeposited Funds", user: current_user).payments.where(deposit: nil)

    if payment_params.length > 0
      @payments.each do |p|
        if payment_params[:payment].key?(p.id.to_s)
          @deposit.payments << p
          @deposit.amount += p.amount
        end
      end
    end


    if @deposit.save
      @deposit.calculate_balance
      flash[:success] = "Deposit successfully saved"
      redirect_to @deposit
    else
      render 'new'
    end
  end

  def show
    redirect_to edit_deposit_path
  end

  def edit
    @payments = @deposit.payments
  end

  def update
    old_amount = @deposit.amount
    @deposit.assign_attributes(deposit_params)
    @account = Account.find_by(name: "Undeposited Funds", user: current_user)
    @payments = @deposit.payments

    if payment_params.length > 0
      @payments.each do |p|
        unless payment_params[:payment].key?(p.id.to_s)
          @deposit.payments.delete(p)
          @deposit.amount -= p.amount
        end
      end
    end 

    if @deposit.save
      @deposit.calculate_balance old_amount
      flash[:success] = "Deposit successfully updated"
      redirect_to @deposit
    else
      render 'new'
    end
  end

  def destroy
    @deposit.destroy
    @deposit.payments.each {|p| p.update_attribute(:deposit, nil)}
    flash[:danger] = "Deposit successfully destroyed"
    redirect_to register_path
  end

  private
  def payment_params
    params.require(:deposit).permit(payment: [:id, :selected])
  end

  def deposit_params
    params.require(:deposit).permit(:date)
  end

  def set_deposit
    @deposit = Deposit.find(params[:id])
  end

  def require_same_user
    if current_user != @deposit.user
      flash[:danger] = "You are not authorized to do that"
      redirect_to root_path
    end
  end
end