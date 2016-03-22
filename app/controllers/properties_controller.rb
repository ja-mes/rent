class PropertiesController < ApplicationController
  def index
    @properties = Property.all
  end

  def new
    @property = Property.new
  end

  def create
    @property = Property.new(property_params)

    if @property.save
      flash[:success] = "Property successfully saved"
      redirect_to property_path(@property)
    else
      render 'new'
    end
  end

  def show
    @property = Property.find(params[:id])
  end

  def edit
    @property = Property.find(params[:id])
  end

  def update
    @property = Property.find(params[:id])
    @stale_property = @property
    if @property.update_attributes(property_params)
      flash[:success] = "Property successfully updated"
      redirect_to edit_property_path
    else
      render 'edit'
    end
  end

  private
  def property_params
    params.require(:property).permit(:address, :city, :state, :zip)
  end
end
