class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  before_action only: [:show, :edit, :update] do
    require_same_user(@account)
  end

  def index
    @accounts = current_user.accounts.order(:name)
  end

  def new
    @account = Account.new
  end

  def create
    debugger
    @account = current_user.accounts.build(account_params)

    if @account.save
      flash[:success] = "Account successfully saved"
      redirect_to accounts_path
    else
      render 'new'
    end
  end

  def show
    trans = @account.account_trans.date_range(params[:from], params[:to])
    @total = trans.calculate_total
    @trans = trans.paginate(page: params[:page])
  end
  
  def edit
  end

  def update
    if @account.update(account_params)
      flash[:success] = 'Account successfully updated'
      redirect_to edit_account_path(@account)
    else
      render 'edit'
    end
  end

  private
  def account_params
    params.require(:account).permit(:name, :type)
  end

  def set_account
    @account = Account.find(params[:id])
  end
end
