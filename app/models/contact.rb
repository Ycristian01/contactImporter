class Contact < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :name, format: { with:  /\A[a-zA-Z0-9 -]+\z/ }
end
