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
    @account_types = current_user.account_types.all
  end

  def create
    @account = current_user.accounts.build(create_params)
    @account_types = current_user.account_types.all

    if @account.save
      flash[:success] = "Account successfully saved"
      redirect_to accounts_path
    else
      render 'new'
    end
  end

  def show
    trans = @account.account_trans.date_range(params[:from], params[:to])
    @total = trans.calculate_total(@account)
    @trans = trans.paginate(page: params[:page])

    @negate = !@account.account_type.inc
  end

  def edit
    @account_types = current_user.account_types.all
  end

  def update
    @account_types = current_user.account_types.all
    
    if @account.update(update_params)
      flash[:success] = 'Account successfully updated'
      redirect_to edit_account_path(@account)
    else
      render 'edit'
    end
  end

  private
  def create_params
    params.require(:account).permit(:name, :account_type_id)
  end

  def update_params
    params.require(:account).permit(:name, :account_type_id)
  end

  def set_account
    @account = Account.find(params[:id])
  end
end
