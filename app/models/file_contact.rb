class FileContact < ApplicationRecord
  has_many :contacts
  has_many :failed_contacts, dependent: :destroy

  has_one_attached :file
end
