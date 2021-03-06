class RecurringTransController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tran, only: [:edit, :update, :destroy]

  before_action only: [:edit, :update, :destroy] do
    require_same_user(@tran)
  end

  def index
    @trans = current_user.recurring_trans
  end

  def create
    model = tran_params[:type].singularize.classify.constantize
    item = model.find_by(user: current_user, id: tran_params[:id])
    RecurringTran.memorize item, tran_params[:due_date], tran_params[:description]
  end

  def edit
  end

  def update
    @tran.update(update_params)
  end

  def destroy
    @tran.destroy
  end

  private
  def set_tran
    @tran = RecurringTran.find(params[:id])
  end

  def tran_params
    params.permit(:id, :type, :due_date, :description)
  end

  def update_params
    params.require(:recurring_tran).permit(:due_date, :description)
  end
end
