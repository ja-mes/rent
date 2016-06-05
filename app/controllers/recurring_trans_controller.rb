class RecurringTransController < ApplicationController
  def index
    @trans = current_user.recurring_trans
  end

  def create
    model = tran_params[:type].singularize.classify.constantize
    item = model.find_by(user: current_user, id: tran_params[:id])
    RecurringTran.memorize item, tran_params[:due_date]

    respond_to do |f|
      f.html
      f.js
    end
  end

  private
  def tran_params
    params.permit(:id, :type, :due_date)
  end
end
