class ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show edit update destroy ]
  
  def index
    @contacts = Contact.all
    @current_user_contacts = current_user.contacts.all
    respond_to do |format|
      format.html
      format.csv { send_data @contacts.to_csv, filename: "contacts -#{Date.today}.csv" }
    end
  end

  def import
    @file_contact = FileContact.new
    @file_contact.name = "contacts -#{Date.today}.csv"
    @file_contact.status = "Loading"
    @file_contact.save!
    @contact = current_user.contacts.create(contact_params)
    current_user.contacts.import(params[:file], current_user, @file_contact)
    flash[:notice] = "Contacts uploaded successfully"
    redirect_to contacts_path
    
  end

  def export_csv
    contact_csv = current_user.contacts.find_by_sql("select * from contact_list limit 10")
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
    
  end

  def failed
    if current_user
      @failed_contacts = Contact.where(user_id: current_user.id, valid_contact: false)
    else
      redirect_to contacts_path
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

    redirect_to contacts_path
    flash[:notice] = "contact was successfully destroyed."
  end

  private

    def set_contact
      @contact = current_user.contacts.find(params[:id])
    end

    def contact_params
      params.permit(:name, :dayOfBirth, :phone, :address, :card, :email, :franchise)
    end

end