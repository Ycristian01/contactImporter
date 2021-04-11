class ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show edit update destroy ]
  before_action :set_contact_file, only: %i[ show edit update destroy ]

  def index
    @contacts = Contact.all

    respond_to do |format|
      format.html
      format.csv { send_data @contacts.to_csv, filename: "contacts -#{Date.today}.csv" }
    end
  end

  def import 
    Contact.import(params[:file])
    redirect_to root_url, notice: "contacts imported"
  end

  def export_csv
    contact_csv = Contact.find_by_sql("select * from contact_list limit 10")
    respond_to do |format|
      format.html
      format.csv { send_data contact_csv.as_csv }
    end
  end

  def show
  end

  def new
   @contact = current_user.contacts.new 
  end

  def edit
  end

  def create
    @contact = current_user.contacts.create(contact_params)
    
    byebug
    if @contact.save
      redirect_to contacts_path 
      flash[:notice] = "Contact was successfully created"
    else
      render 'show'
    end
  end

  def update
    if @contact.update(contact_params) 
      redirect_to contact_path 
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

    def set_user
      @contact_file = ContactFile.find(params[:contact_file_id])
    end

    def contact_params
      params.require(:contact).permit(:name, :dayOfBirth, :phone, :address, :card, :franchise, :email) 
    end

end
