class ContactsController < ApplicationController
  before_action :set_user
  before_action :set_contact, only: %i[ show edit update destroy ]

  def show
  end

  def index
    @contact = Contact.all
  end

  def new
   @contact = @user.contacts.new 
  end

  def edit
  end

  def create
    @contact = @user.contacts.create(contact_params)
 
     if @contact.save
       redirect_to user_contacts_path @user
       flash[:notice] = "Contact was successfully created"
     else
       render 'users#index'
     end
   end

  def update
    if @contact.update(contact_params) 
      redirect_to user_contact_path @user
      flash[:notice] = "contact was successfully updated." 
    else
      render 'edit'
    end   
  end

  def destroy
    @contact.destroy

    redirect_to user_path @user
    flash[:notice] = "contact was successfully destroyed." 
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    end
      
    def set_contact
      @contact = @user.contacts.find(params[:id]) 
    end

    def contact_params
      params.require(:contact).permit(:name, :dayOfBirth, :phone, :address, :card, :franchise, :email) 
    end

end
