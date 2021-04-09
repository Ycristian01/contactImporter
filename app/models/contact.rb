class Contact < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :name, format: { with:  /\A[a-zA-Z0-9 -]+\z/ }
  #validates_format_of :dayOfBirth, :with => /\d{4}\-\d{2}\-\d{2}/, :message => " Date must be in the following format: yyyy-mm-dd"
  # format_str = "%m/%d/" + (date_str =~ /\d{4}/ ? "%Y" : "%y")
  #   date = Date.parse(date_str) rescue Date.strptime(date_str, format_str)
  validates_each :dayOfBirth do |record, attribute, value|
    begin
      value.include?("-") ? Date.strptime(value.to_s,"%F") : Date.strptime(value.to_s,"%Y%m%d")
    rescue
      record.errors.add(:dayOfBirth, :invalid)
    end
  end
  validates :phone, numericality: { only_integer: true,
    message: "only allows numbers"}
  validates :address, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :card, numericality: { only_integer: true,
    message: "only allows numbers" }
  validates :card, length: { is: 6 }
  validates :franchise, format: { with: /\A[a-zA-Z]+\z/,
    message: "only allows letters" }

end
