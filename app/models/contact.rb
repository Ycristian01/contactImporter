require 'csv'
require 'bcrypt'

class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :file_contact

  validates :name, presence: true
  validates :name, format: { with:  /\A[A-Za-z\-\s]*\z/ }
  validates :address, presence: true
  validates :dayOfBirth, presence: true
  validates :card, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, format: { with: /\(([+][0-9]{1,2})\)([ .-]?)([0-9]{3})(\s|-)([0-9]{3})(\s|-)([0-9]{2})(\s|-)([0-9]{2})/, message: 'Invalid phone number' }, presence: true
  validates :card, numericality: { only_integer: true,
    message: "only allows numbers" }

  validates_each :dayOfBirth do |record, attribute, value|
    begin
      value.include?("-") ? Date.strptime(value.to_s,"%F") : Date.strptime(value.to_s,"%Y%m%d")
    rescue
      record.errors.add(:dayOfBirth, :invalid)
    end
  end

  validate :valid_card
  before_save -> do
    self.last_four_numbers = self.card[-4..-1]
    self.franchise = valid_association
    self.encrypted_card_number = BCrypt::Password.create(card)
  end
  private

  def valid_card()
    number = self.card.gsub(/\D/, "")
    return false unless valid_association
    number.reverse!
  
    relative_number = {'0' => 0, '1' => 2, '2' => 4, '3' => 6, '4' => 8, '5' => 1, '6' => 3, '7' => 5, '8' => 7, '9' => 9}
  
    sum = 0 
    
    number.split("").each_with_index do |n, i|
      sum += (i % 2 == 0) ? n.to_i : relative_number[n]
    end 
    sum % 10 == 0
  end

  def valid_association
    number = self.card.gsub(/\D/, "")
    
    return 'Dinners'  if number.length == 14 && number =~ /^3(0[0-5]|[68])/   # 300xxx-305xxx, 36xxxx, 38xxxx
    return 'Amex'     if number.length == 15 && number =~ /^3[47]/            # 34xxxx, 37xxxx
    return 'Visa'     if [13,16].include?(number.length) && number =~ /^4/    # 4xxxxx
    return 'Master'   if number.length == 16 && number =~ /^5[1-5]/           # 51xxxx-55xxxx
    return 'Discover' if number.length == 16 && number =~ /^6011/             # 6011xx
    return nil
  end

  def self.to_csv
    og_headers = ["name", "dayOfBirth", "phone", "address", "card", "franchise", "email"]
    attributes = og_headers

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |contact|
        csv << attributes.map{ |attr| contact.send(attr) }
      end
    end

  end

  def self.import(file, file_contact_params, file_contact, user)
    failed= 0
    cont_ = 0
    CSV.foreach(ActiveStorage::Blob.service.send(:path_for, file_contact.file.key), headers: true) do |row|
      contact_errors = []
      file_hash = row.to_hash
      
      file_contact.status = "Processing"
      contact_hash = Contact.new(name: file_hash[file_hash.keys[file_contact_params['name'].to_i]],
      dayOfBirth: file_hash[file_hash.keys[file_contact_params['dayOfBirth'].to_i]],
      phone: file_hash[file_hash.keys[file_contact_params['phone'].to_i]],
      address: file_hash[file_hash.keys[file_contact_params['address'].to_i]],
      card: file_hash[file_hash.keys[file_contact_params['card'].to_i]],
      email: file_hash[file_hash.keys[file_contact_params['email'].to_i]], user_id: user.id,
      file_contact_id: file_contact.id)
      
      
      if contact_hash.save
        contact_hash.valid_contact = true
      else
        contact_errors = contact_hash.errors.full_messages.join(',')
        failed_contact = FailedContact.new(name: file_hash[file_hash.keys[file_contact_params['name'].to_i]],
          dayOfBirth: file_hash[file_hash.keys[file_contact_params['dayOfBirth'].to_i]],
          phone: file_hash[file_hash.keys[file_contact_params['phone'].to_i]],
          address: file_hash[file_hash.keys[file_contact_params['address'].to_i]],
          card: file_hash[file_hash.keys[file_contact_params['card'].to_i]],
          email: file_hash[file_hash.keys[file_contact_params['email'].to_i]],
          file_contact_id: file_contact.id, contact_errors: contact_errors)
        failed_contact.save!
        failed += 1
        
      end

      cont_ = cont_+1

      if failed == CSV.foreach(ActiveStorage::Blob.service.send(:path_for, file_contact.file.key), headers: true).count
        file_contact.status = "Failed"
      elsif failed < CSV.foreach(ActiveStorage::Blob.service.send(:path_for, file_contact.file.key), headers: true).count && cont_ == CSV.foreach(ActiveStorage::Blob.service.send(:path_for, file_contact.file.key), headers: true).count
        file_contact.status = "Finished"
      end
        
    end
    file_contact.save!
  end
  
end
