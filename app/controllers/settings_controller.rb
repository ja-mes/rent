class SettingsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def update_checkbook_balance 
    current_user.checkbook.set_beginning_balance(params[:balance].to_d) if params[:balance]
  end
end
