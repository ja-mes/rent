class RecurringTransController < ApplicationController
  def index
    @trans = current_user.recurring_trans
  end

  def create
    model = tran_params[:type].singularize.classify.constantize
    item = model.find_by(user: current_user, id: tran_params[:id])
    RecurringTran.memorize item, tran_params[:due_date]
  end

  def edit
    @tran = RecurringTran.find(params[:id])
  end

  def update
    @tran = RecurringTran.find(params[:id])
    
    if @tran.update(update_params)
    else
    end
  end

  private
  def tran_params
    params.permit(:id, :type, :due_date)
  end

  def update_params
    params.require(:recurring_tran).permit(:due_date)
  end
end
