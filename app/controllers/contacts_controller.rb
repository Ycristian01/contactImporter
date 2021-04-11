class ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show edit update destroy ]

  

  def index
    @contacts = Contact.all

    respond_to do |format|
      format.html
      format.csv { send_data @contacts.to_csv, filename: "contacts -#{Date.today}.csv" }
    end
  end

  def import 
    Employee.import(params[:file])
    redirect_to root_url, notice: "contacts imported"
  end

  def show
  end

  def new
   @contact = current_user.contacts.new 
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
    
    def set_contact
      @contact = current_user.contacts.find(params[:id]) 
    end

    def contact_params
      params.require(:contact).permit(:name, :dayOfBirth, :phone, :address, :card, :franchise, :email) 
    end

end
