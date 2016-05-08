class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user, only: [:show, :edit, :update]

  def index
    @accounts = current_user.accounts.order(:name)
  end

  def new
    @account = Account.new
  end

  def create
    @account = current_user.accounts.build(account_params)

    if @account.save
      flash[:success] = "Account successfully saved"
      redirect_to accounts_path
    else
      render 'new'
    end
  end

  def show
    @account = current_user.accounts.find(params[:id])
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
    params.require(:account).permit(:name)
  end

  def set_account
    @account = Account.find(params[:id])
  end

  def require_same_user
    if current_user != @account.user
      flash[:danger] = "You are not authorized to do that"
      redirect_to root_path
    end
  end
end
