class ReconciliationsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
    @reconciliation = Reconciliation.new
    @checks = Check.where(user: current_user, cleared: false).order('date DESC')
    @deposits = Deposit.where(user: current_user, cleared: false).order('date DESC')
    @register = Register.find_by(user: current_user, name: "Checking")
    render layout: "fluid"
  end
  
  def create
    @reconciliation = Reconciliation.new(user: current_user)
    debugger
    @reconciliation.setup_trans(tran_params)
  end

  def edit
  end

  def update
  end

  private
  def tran_params
    params.require(:reconciliation).permit(deposits: [:id, :selected], checks: [:id, :selected])
  end

  def reconciliation_params
    params.require(:reconciliation).permit(:ending_balance)
  end
end
