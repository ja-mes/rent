class ChecksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_check, only: [:edit, :update, :destroy]
  before_action :set_vars, except: [:index, :show, :destroy]

  def index
    redirect_to new_check_path
  end

  def new
    @check = Check.new
    @check.account_trans.build
  end

  def create
    @check = current_user.checks.new(check_params)
    @check.account_trans.each {|tran| tran.user = current_user}

    if @check.save
      flash[:success] = "Check successfully saved"
      redirect_to @check
    else
      render 'new'
    end
  end

  def show
    redirect_to edit_check_path(params[:id])
  end

  def edit
  end

  def update
    old_amount = @check.amount

    @check.attributes = check_params
    @check.account_trans.each {|tran| tran.user = current_user}

    if @check.save
      @check.calculate_balance old_amount
      flash[:success] = "Check successfully updated"
      redirect_to @check
    else
      render 'edit'
    end
  end

  def destroy
    @check.destroy

    flash[:danger] = "Check successfully deleted"
    redirect_to register_path
  end

  private
  def check_params
    params.require(:check).permit(:amount, :date, :memo, :num, account_trans_attributes: [:id, :account_id, :property_id, :amount, :memo, :_destroy])
  end

  def set_check
    @check = Check.find(params[:id])
  end

  def set_vars
    @accounts = current_user.accounts
    @properties = current_user.properties
  end
end
