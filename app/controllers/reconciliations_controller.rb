class ReconciliationsController < ApplicationController
  def index
  end

  def new
    @reconciliation = Reconciliation.new
    @checks = Check.where(user: current_user, cleared: false).order('date DESC')
    @deposits = Deposit.where(user: current_user, cleared: false).order('date DESC')
    render layout: "fluid"
  end
  
  def create
    @reconciliation = Reconciliation.new(user: current_user)
    @reconciliation.setup_trans(reconciliation_params)
  end

  def edit
  end

  def update
  end

  private
  def reconciliation_params
    params.require(:reconciliation).permit(deposits: [:id, :selected])
  end
end
