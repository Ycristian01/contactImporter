class FileContactsController < ApplicationController
  def index
    if current_user
      @file_contacts = FileContact.all
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
    @file_contact = FileContact.new(name: params[:file_contact][:file].original_filename, file: params[:file_contact][:file], status: "standby", index_params: file_contact_params)
    @file_contact.save!
    redirect_to file_contacts_path
  end

  private

    def file_contact_params
      params.permit(:name, :dayOfBirth, :phone, :address, :card, :email)
    end
end
