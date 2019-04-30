class RecipientsController < ApplicationController
  before_action :set_recipient, only: [:show, :edit, :update, :destroy]
  def index
    @user = session[:user]
    @recipients = Recipient.order('name ASC').all
  end
#
  def show
    @user = session[:user]
  end
#
  def new
    @user = session[:user]
    @recipient = Recipient.new
  end
#
  def create
    if (params[:commit] == "Exit")
      redirect_to recipients_path
      return
    end
    @recipient = Recipient.new(recipient_params)
    if @recipient.save
      redirect_to @recipient, notice: 'Recipient was successfully created.'
    else
      render :new
    end
  end
#
  def edit
    @user = session[:user]
  end

  def update
    if (params[:commit] == "Exit")
      redirect_to recipients_path
      return
    end

    if @recipient.update(recipient_params)
      redirect_to @recipient, notice: 'Recipient was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @recipient.destroy
      redirect_to recipients_path, notice: 'Recipient was successfully destroyed.'
    else
      render :edit
    end
  end

  private

  def set_recipient
    @recipient = Recipient.find(params[:id])
  end

  def recipient_params
    params.require(:recipient).permit(:id, :name, :email, :_destroy)
  end
end
