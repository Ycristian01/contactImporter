require 'csv'

class Contact < ApplicationRecord
  belongs_to :user
  #belongs_to :contact_file

  validates :name, presence: true
  validates :name, format: { with:  /[A-Za-z0-9\-\s]/ }
  validates :address, presence: true
  validates :dayOfBirth, presence: true
  validates :card, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, format: { with: /\(([+][0-9]{1,2})\)([ .-]?)([0-9]{3})(\s|-)([0-9]{3})(\s|-)([0-9]{2})(\s|-)([0-9]{2})/, message: 'Invalid phone number' }, presence: true
  validates :card, numericality: { only_integer: true,
    message: "only allows numbers" }
  # validates :franchise, format: { with:  /\A[a-zA-Z0-9 ]+\z/ }

  validates_each :dayOfBirth do |record, attribute, value|
    begin
      value.include?("-") ? Date.strptime(value.to_s,"%F") : Date.strptime(value.to_s,"%Y%m%d")
    rescue
      record.errors.add(:dayOfBirth, :invalid)
    end
  end

  validate :valid_card
  before_save -> do
    self[:last_four_numbers] = card[-4..-1]
    self[:franchise] = valid_association
  end

  private

  def valid_card
    number = card.gsub(/\D/, "")
  
    return false unless valid_association
    number.reverse!
  
    relative_number = {'0' => 0, '1' => 2, '2' => 4, '3' => 6, '4' => 8, '5' => 1, '6' => 3, '7' => 5, '8' => 7, '9' => 9}
  
    sum = 0 
    
    card.split("").each_with_index do |n, i|
      sum += (i % 2 == 0) ? n.to_i : relative_number[n]
    end 
    sum % 10 == 0
  end

  def valid_association
    
    number = card.gsub(/\D/, "") 
    return 'Dinners'  if number.length == 14 && number =~ /^3(0[0-5]|[68])/   # 300xxx-305xxx, 36xxxx, 38xxxx
    return 'Amex'     if number.length == 15 && number =~ /^3[47]/            # 34xxxx, 37xxxx
    return 'Visa'     if [13,16].include?(number.length) && number =~ /^4/    # 4xxxxx
    return 'Master'   if number.length == 16 && number =~ /^5[1-5]/           # 51xxxx-55xxxx
    return 'Discover' if number.length == 16 && number =~ /^6011/             # 6011xx
    return nil
  end

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
