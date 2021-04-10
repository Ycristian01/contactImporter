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
  validates :franchise, format: { with: /\A[a-zA-Z]+\z/,
    message: "only allows letters" }

  validates_each :dayOfBirth do |record, attribute, value|
    begin
      value.include?("-") ? Date.strptime(value.to_s,"%F") : Date.strptime(value.to_s,"%Y%m%d")
    rescue
      record.errors.add(:dayOfBirth, :invalid)
    end
  end

  validate :validate_card
  before_save :save_card

  private

  def validate_credit_card
    self[:card] = detect_franchise
    self[:last_four_numbers] = take_last_four_credit_card_numbers
    errors.add(:card, 'Invalid credit card') if franchise.nil?
  end

  # def valid_card
  #   self[:card] = self[:card].gsub(/\D/, "")
  
  #   return false unless valid_association(self[:card])
  #   self[:card].reverse!
  
  #   relative_number = {'0' => 0, '1' => 2, '2' => 4, '3' => 6, '4' => 8, '5' => 1, '6' => 3, '7' => 5, '8' => 7, '9' => 9}
  
  #   sum = 0 
  
  #   self[:card].split("").each_with_index do |n, i|
  #     sum += (i % 2 == 0) ? n.to_i : relative_number[n]
  #   end 
  
  #   sum % 10 == 0
  # end

  # def valid_association(number)
  #   number = number.to_s.gsub(/\D/, "") 
  
  #   return :dinners  if number.length == 14 && number =~ /^3(0[0-5]|[68])/   # 300xxx-305xxx, 36xxxx, 38xxxx
  #   return :amex     if number.length == 15 && number =~ /^3[47]/            # 34xxxx, 37xxxx
  #   return :visa     if [13,16].include?(number.length) && number =~ /^4/    # 4xxxxx
  #   return :master   if number.length == 16 && number =~ /^5[1-5]/           # 51xxxx-55xxxx
  #   return :discover if number.length == 16 && number =~ /^6011/             # 6011xx
  #   return nil
  # end
end
