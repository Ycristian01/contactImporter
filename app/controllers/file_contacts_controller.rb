class FileContactsController < ApplicationController
  def index
    @file_contact = FileContact.all
  end
end
