class ReconciliationsController < ApplicationController
  def index
  end

  def new
    @checks = Check.where(user: current_user, cleared: false).order('date DESC')
    @deposits = Deposit.where(user: current_user, cleared: false).order('date DESC')
    render layout: "fluid"
  end
  
  def create
  end

  def edit
  end

  def update
  end

  private
end
