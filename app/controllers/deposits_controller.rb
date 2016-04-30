class DepositsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_same_user, only: [:show, :update, :edit, :delete]

  def index
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def deposit_params
    params.require(:deposits).permit()
  end

  def require_same_user
    if current_user != @customer.user
      flash[:danger] = "You are not authorized to do that"
      redirect_to root_path
    end
  end
end
