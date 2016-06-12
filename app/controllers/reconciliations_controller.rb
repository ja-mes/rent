class ReconciliationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @reconciliations = current_user.reconciliations
  end

  def new
    @reconciliation = Reconciliation.new
    @checks = Check.where(user: current_user, cleared: false).order('date DESC')
    @deposits = Deposit.where(user: current_user, cleared: false).order('date DESC')
    @register = Register.find_by(user: current_user, name: "Checking")
    render layout: "fluid"
  end
  
  def create
    @reconciliation = current_user.reconciliations.new(reconciliation_params.except(:deposits, :checks))

    # TODO pass theses records to prepare method instead of reloading them
    @checks = Check.where(user: current_user, cleared: false).order('date DESC')
    @deposits = Deposit.where(user: current_user, cleared: false).order('date DESC')
    @register = Register.find_by(user: current_user, name: "Checking")

    @reconciliation.setup_trans(reconciliation_params)

    if @reconciliation.save
      flash[:success] = "Successfully reconciled"
      redirect_to reconciliations_path
    else
      render 'new', layout: 'fluid'
    end
  end

  def edit
  end

  def update
  end

  private
  def reconciliation_params
    params.require(:reconciliation).permit(:date, :ending_balance, deposits: [:id, :selected], checks: [:id, :selected])
  end
end
