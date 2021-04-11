require 'csv'

class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :contact_file

  validates :name, presence: true
  validates :name, format: { with:  /\A[a-zA-Z0-9 -]+\z/ }
  validates :address, presence: true
  validates :dayOfBirth, presence: true
  validates :card, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, format: { with: /\(([+][0-9]{1,2})\)([ .-]?)([0-9]{3})(\s|-)([0-9]{3})(\s|-)([0-9]{2})(\s|-)([0-9]{2})/, message: 'Invalid phone number' }, presence: true
  validates :card, numericality: { only_integer: true,
    message: "only allows numbers" }
  validates :franchise, format: { with:  /\A[a-zA-Z0-9 ]+\z/ }

  validates_each :dayOfBirth do |record, attribute, value|
    begin
      value.include?("-") ? Date.strptime(value.to_s,"%F") : Date.strptime(value.to_s,"%Y%m%d")
    rescue
      record.errors.add(:dayOfBirth, :invalid)
    end
  end

  # validate :validate_card
  # before_save :save_card

  private

  # def validate_credit_card
  #   self[:card] = detect_franchise
  #   self[:last_four_numbers] = take_last_four_credit_card_numbers
  #   errors.add(:card, 'Invalid credit card') if franchise.nil?
  # end

def self.to_csv
    attributes = %w{name dayOfBirth phone address card franchise email }

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |contact|
        csv << attributes.map{ |attr| contact.send(attr) }
      end
    end

  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      contact_hash = row.to_hash
      contact = find_or_create_by!(name: contact_hash['name'], dayOfBirth: contact_hash['dayOfBirth'], phone: contact_hash['phone'],
        address: contact_hash['address'], card: contact_hash['card'], franchise: contact_hash['franchise'], email: contact_hash['email'])
      contact.update(contact_hash)
    end
  end
end
