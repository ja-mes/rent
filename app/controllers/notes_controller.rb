class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer
  before_action :set_note, only: [:edit, :update, :destroy]

  before_action do
    require_same_user(@customer)
  end
  before_action only: [:show, :edit, :update, :destroy] do
    require_same_user(@note)
  end

  def index
    @note = Note.new
    @notes = current_user.notes.where(customer: @customer)
  end

  def new 
    @note = Note.new
  end

  def create
    @note = current_user.notes.build(note_params)
    @note.customer = @customer

    if @note.save
    else
    end
  end

  def edit
  end

  def update
    if @note.update(note_params)
    else
    end
  end

  def destroy
    @note.destroy
  end

  private
  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:content)
  end
end
