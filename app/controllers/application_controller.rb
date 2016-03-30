class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def setup_date(obj)
    begin
      obj.date = Date.strptime(payment_params[:date], "%m/%d/%Y")
    rescue
      obj.errors.add(:date)
      render 'new'
      return
    end
  end
end
