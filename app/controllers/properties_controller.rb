class PropertiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_property, only: [:show, :edit, :update]

  before_action only: [:show, :edit, :update] do
    require_same_user(@property)
  end

  def index
    @properties = Property.search(params[:search], current_user).paginate(page: params[:page]).order(:address)
  end

  def new
    @property = Property.new
  end

  def create
    @property = current_user.properties.build(property_params)

    if @property.save
      flash[:success] = "Property successfully saved"
      redirect_to property_path(@property)
    else
      render 'new'
    end
  end

  def show
    trans = @property.account_trans.date_range(params[:from], params[:to])
    @total = trans.calculate_property_total
    @trans = trans.paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @property.update(property_params)
      flash[:success] = "Property successfully updated"
      redirect_to edit_property_path
    else
      render 'edit'
    end
  end

  private
  def property_params
    params.require(:property).permit(:address, :city, :state, :zip, :deposit, :rent)
  end

  def set_property
    @property = Property.find(params[:id])
  end
end
