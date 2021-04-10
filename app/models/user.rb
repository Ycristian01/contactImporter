class User < ApplicationRecord
  has_many :contacts, dependent: :destroy
  has_many :contact_files, dependent: :destroy
  
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # def self.to_csv
  #   attributes = %w{name dayOfBirth phone address card franchise email }

  #   CSV.generate(headers: true) do |csv|
  #     csv << attributes

  #     all.each do |employee|
  #       csv << attributes.map{ |attr| employee.send(attr) }
  #     end
  #   end

  # end

  # def self.import(file)
  #   CSV.foreach(file.path, headers: true) do |row|
  #     employee_hash = row.to_hash
  #     employee = find_or_create_by!(name: employee_hash['name'], surname: employee_hash['surname'], phone: employee_hash['phone'],
  #       email: employee_hash['email'], post: employee_hash['post'], salary: employee_hash['salary'], department: employee_hash['department'])
  #     employee.update(employee_hash)
  #   end
  # end
end
