module AccountsHelper
  def from_date
    if params[:from]
      Date.new params[:from]["date(1i)"].to_i, params[:from]["date(2i)"].to_i, params[:from]["date(3i)"].to_i
    end
  end

  def to_date
    if params[:to]
      Date.new params[:to]["date(1i)"].to_i, params[:to]["date(2i)"].to_i, params[:to]["date(3i)"].to_i
    end
  end
end
