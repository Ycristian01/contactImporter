class User < ApplicationRecord
  has_many :contacts, dependent: :destroy
  #has_many :contact_files, dependent: :destroy
  
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
