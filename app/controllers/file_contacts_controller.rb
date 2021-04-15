class FileContactsController < ApplicationController
  before_action :set_file_contact, only: %i[ show edit update destroy ]

  def index
    if current_user
      @file_contacts = FileContact.all.order([created_at: :desc])
      @file_contacts = @file_contacts.paginate(page: params[:page], per_page: 10)
      respond_to do |format|
        format.html
        format.json { render json: @file_contacts }
      end 
    else
      redirect_to users_path
    end
  end

  def new
    @file_contact = FileContact.new
   end

  def import
    @file_contact = FileContact.find(params[:id])
  
    Contact.import(@file_contact.file,JSON.parse(@file_contact.index_params.gsub("=>",":")), @file_contact, current_user)
    flash[:notice] = "Contacts uploaded successfully"
    redirect_to file_contacts_path
  end

  def create
    @file_contact = FileContact.new(name: params[:file_contact][:file].original_filename, file: params[:file_contact][:file], status: "Standby", index_params: file_contact_params)
    @file_contact.save!
    redirect_to file_contacts_path
  end

  def destroy
    @file_contact.destroy

    redirect_to file_contacts_path
    flash[:notice] = "contact file was successfully destroyed."
  end


  private

    def set_file_contact
      @file_contact = FileContact.find(params[:id])
    end

    def file_contact_params
      params.permit(:name, :dayOfBirth, :phone, :address, :card, :email)
    end
end
