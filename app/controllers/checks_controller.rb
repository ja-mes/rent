class ChecksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_check, only: [:edit, :update, :destroy]

  def index
    redirect_to new_check_path
  end

  def new
    @check = Check.new
  end

  def create
    @check = current_user.checks.new(check_params)

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
    if @check.update(check_params)
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
    params.require(:check).permit(:amount, :date, :memo, :num)
  end

  def set_check
    @check = Check.find(params[:id])
  end
end
