class PropertiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_property, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:show, :edit, :update]

  def index
    @properties = Property.search(params[:search], current_user).paginate(page: params[:page], per_page: 5)
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

  def require_same_user
    if current_user != @property.user
      flash[:danger] = "You are not authorized to do that"
      redirect_to root_path
    end
  end
end
