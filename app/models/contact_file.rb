class ContactFile < ApplicationRecord
  belongs_to :user
  has_one_attached :csv_file
  has_many :contacts, dependent: :destroy
  
  validates :name, presence: true
  validates :og_headers, presence: true
  validates :status, presence: true
  
end
