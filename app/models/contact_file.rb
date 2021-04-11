class ContactFile < ApplicationRecord
  belongs_to :user
  has_one_attached :csv_file
  #has_many :contacts, dependent: :destroy
  has_many :failed_contacts, dependent: :destroy
  validates :name, presence: true
  validates :og_headers, presence: true
  validates :status, presence: true

  def change_status
    created_contacts = contacts.count
    created_failed_contacts = failed_contacts.count

    finished! if created_contacts.positive? || created_contacts < created_failed_contacts
    failed! if created_contacts.zero? && created_failed_contacts.positive?
  end
   
end
