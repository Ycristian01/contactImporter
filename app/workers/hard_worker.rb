class HardWorker
  include Sidekiq::Worker

  def perform(*args)
    @file_contact = FileContact.find(params[:id])
  
    Contact.import(@file_contact.file,JSON.parse(@file_contact.index_params.gsub("=>",":")), @file_contact, current_user)
    flash[:notice] = "Contacts uploaded successfully"
    redirect_to file_contacts_path
    sleep 2
  end
end
