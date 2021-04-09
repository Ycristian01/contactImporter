require 'rails_helper'

RSpec.describe Contact, type: :model do
  
  it "is valid with valid attributes" do
    contact = build(:contact)
    expect(contact).to be_valid
  end

  it "tests contact name" do
    contact = build(:contact)
    contact.name = "Cristian-Yepes*"
    expect(contact).to_not be_valid
  end

  it "tests contact day of birth" do
    contact = build(:contact)
    contact.dayOfBirth = '1998-100-01'
    expect(contact).to_not be_valid
  end

  it "tests contact phone" do
    contact = build(:contact)
    contact.phone = "numero"
    expect(contact).to_not be_valid
  end
  
  it "tests contact card" do
    contact = build(:contact)
    contact.card = "58876898767card"
    expect(contact).to_not be_valid
  end

  it "tests contact franchise" do
    contact = build(:contact)
    contact.franchise = 1234
    expect(contact).to_not be_valid
  end
  
  # it "tests contact email" do
  #   contact = build(:contact)
  #   expect(contact.email).to eq('examplecontact7@example.com')
  # end
end
