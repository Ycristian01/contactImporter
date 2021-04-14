class FileContactsController < ApplicationController
  def index
    if current_user
      @file_contacts = FileContact.all
    else
      redirect_to users_path
    end
  end
end
