class FileContact < ApplicationRecord
  has_many :contacts, dependent: :destroy
  has_many :file_contacts, dependent: :destroy

  has_one_attached :file
end
