require 'rails_helper'

RSpec.describe Contact, type: :model do
  
  context 'custom validations' do
    let(:email) { 'testtest.com' }
    let(:phone) { '3193206968' }
    let(:dayOfBirth) { '1995/12/12' }
    let(:card) { '112124234f' }
    let(:new_contact) { Contact.new }

    it 'email is invalid with message' do
      new_contact.email = email
      new_contact.valid?

      expect(new_contact.errors[:email]).to include('Invalid email')
    end
  
  end

  # it "is valid with valid attributes" do
  #   contact = build(:contact)
  #   expect(contact).to be_valid
  # end

  # it "tests contact name" do
  #   contact = build(:contact)
  #   contact.name = "Cristian-Yepes*"
  #   expect(contact).to_not be_valid
  # end

  # it "tests contact day of birth" do
  #   contact = build(:contact)
  #   contact.dayOfBirth = '1998-100-01'
  #   expect(contact).to_not be_valid
  # end

  # it "tests contact phone" do
  #   contact = build(:contact)
  #   contact.phone = "numero"
  #   expect(contact).to_not be_valid
  # end
  
  # it "tests contact card" do
  #   contact = build(:contact)
  #   contact.card = "4111111111111111"
  #   expect(contact).to be_valid
  # end

  # it "tests contact franchise" do
  #   contact = build(:contact)
  #   contact.franchise = 1234
  #   expect(contact).to_not be_valid
  # end
  
  # it "tests contact email" do
  #   contact = build(:contact)
  #   expect(contact.email).to eq('examplecontact7@example.com')
  # end
end
