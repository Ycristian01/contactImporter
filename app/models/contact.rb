class Contact < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :name, format: { with:  /\A[a-zA-Z0-9 -]+\z/ }
  validates_format_of :dayOfBirth, :with => /\d{4}\-\d{2}\-\d{2}/, :message => "^Date must be in the following format: yyyy-mm-dd"
  validates :phone, numericality: { only_integer: true }
  validates :address, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

end
