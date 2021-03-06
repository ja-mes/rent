class VendorsController < ApplicationController
  efore_action :authenticate_user!
  before_action :set_vendor, only: [:show, :edit, :update, :destroy]
  before_action only: [:show, :edit, :update, :destroy] do
    require_same_user(@vendor)
  end

  def index
    @vendors = current_user.vendors.paginate(page: params[:page])
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = current_user.vendors.build(vendor_params)

    if @vendor.save
      flash[:success] = "Vendor successfully saved"
      redirect_to @vendor
    else
      render 'new'
    end
  end

  def show
    @trans = current_user.checks.where(vendor: @vendor).date_range(params[:from], params[:to])
    @total = @trans.sum(:amount)
  end

  def edit
  end

  def update
    if @vendor.update(vendor_params)
      flash[:success] = "Vendor successfully updated"
      redirect_to edit_vendor_path
    else
      render 'edit'
    end
  end

  def destroy
  end

  private
  def set_vendor
    @vendor = Vendor.find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(:name, :address, :city, :state, :zip, :phone)
  end
end
