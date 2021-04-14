require 'csv'
require 'bcrypt'

class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :file_contact, class_name: 'FileContact', foreign_key: 'file_contact_id', optional: true

  validates :name, presence: true
  validates :name, format: { with:  /[A-Za-z0-9\-\s]/ }
  validates :address, presence: true
  validates :dayOfBirth, presence: true
  validates :card, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, format: { with: /\(([+][0-9]{1,2})\)([ .-]?)([0-9]{3})(\s|-)([0-9]{3})(\s|-)([0-9]{2})(\s|-)([0-9]{2})/, message: 'Invalid phone number' }, presence: true
  validates :card, numericality: { only_integer: true,
    message: "only allows numbers" }

  private

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

  def self.import(file, user, contact_params, file_contact)
    failed= 0
    CSV.foreach(file.path, headers: true) do |row|
      contact_errors = []
      contact_hash = Contact.new
      file_hash = row.to_hash
      byebug
      contact_hash.file_contact_id = file_contact.id

      file_contact.status = "Processing"
      contact_hash.user_id = user.id
      name_ = file_hash['name']
      if name_
        contact_hash.name = name_
      else 
        contact_errors.push("Name empty")
      end
      date_ = file_hash['dayOfBirth']
      if date_
        if date_.include? "-"
          dayOfBirth =  Date.strptime(date_.to_s, '%F')
        elsif date_.length == 8
          dayOfBirth = Date.strptime(date_.to_s, '%Y%m%d')
        else
          contact_errors.push("wrong date format")
        end
        contact_hash.dayOfBirth = dayOfBirth
      else
        contact_errors.push("Date empty")
      end
      phone_ = file_hash['phone']
      if phone_
        if !phone_.match(/\(\+\d{1,2}\)\s\d{3}\s\d{3}\s\d{2}\s\d{2}/).nil? || !phone_.match(/\(\+\d{1,2}\)\s\d{3}\-\d{3}\-\d{2}\-\d{2}/).nil?
          contact_hash.phone = phone_
        else
          contact_errors.push("phone field don't accepted. Must be (+00) 000 000 00 00 or (+00) 000-000-00-00")
        end
      else
        contact_errors.push("Phone field empty")
      end

      address_ = file_hash['address']
      if address_
        contact_hash.address = address_
      else
        errors.push("Address field empty")
      end

      card_ = file_hash['card'].to_s
      if card_.length == 14 && card_ =~ /^3(0[0-5]|[68])/   # 300xxx-305xxx, 36xxxx, 38xxxx
        franchise_= 'Dinners'
      elsif card_.length == 15 && card_ =~ /^3[47]/            # 34xxxx, 37xxxx
        franchise_= 'Amex'
      elsif [13,16].include?(card_.length) && card_ =~ /^4/    # 4xxxxx   
        franchise_= 'Visa'     
      elsif card_.length == 16 && card_ =~ /^5[1-5]/ 
        franchise_= 'Master'             # 51xxxx-55xxxx
      elsif card_.length == 16 && card_ =~ /^6011/             # 6011xx
        franchise_= 'Discover' 
      else
        franchise_= nil
      end

      if franchise_==nil
        contact_errors.push("It is not a valid card number")
      else
        contact_hash.franchise = franchise_
        contact_hash.card = card_
        contact_hash.encrypted_card_number = BCrypt::Password.create(card_)
        contact_hash.last_four_numbers = card_[-4..-1]
      end

      email = file_hash['email']
      if email
        unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
            contact_errors.push("It is not a valid email")
        else 
            contact_hash.email = email
        end       
      else
        contact_errors.push("Email field empty")
      end
        
      if !contact_errors.empty?
        contact_hash.contact_errors = contact_errors.join(',')
        contact_hash.valid_contact = false
        failed += 1
      else
        contact_hash.valid_contact = true
      end
      contact_hash.save!
      if failed == CSV.foreach(file.path, headers: true).count
        file_contact.status = "Failed"
      elsif failed < CSV.foreach(file.path, headers: true).count
        file_contact.status = "Finished"
      end
        
    end
    file_contact.save!
  end

  def valid_card(number)
    #byebug
    return false unless valid_association(number)
    number.reverse!
  
    relative_number = {'0' => 0, '1' => 2, '2' => 4, '3' => 6, '4' => 8, '5' => 1, '6' => 3, '7' => 5, '8' => 7, '9' => 9}
  
    sum = 0 
    
    number.split("").each_with_index do |n, i|
      sum += (i % 2 == 0) ? n.to_i : relative_number[n]
    end 
    sum % 10 == 0
  end

  def valid_association(number)
    number = card.gsub(/\D/, "")
    
    return 'Dinners'  if number.length == 14 && number =~ /^3(0[0-5]|[68])/   # 300xxx-305xxx, 36xxxx, 38xxxx
    return 'Amex'     if number.length == 15 && number =~ /^3[47]/            # 34xxxx, 37xxxx
    return 'Visa'     if [13,16].include?(number.length) && number =~ /^4/    # 4xxxxx
    return 'Master'   if number.length == 16 && number =~ /^5[1-5]/           # 51xxxx-55xxxx
    return 'Discover' if number.length == 16 && number =~ /^6011/             # 6011xx
    return nil
  end
end
