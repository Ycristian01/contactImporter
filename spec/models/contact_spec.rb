require 'rails_helper'

RSpec.describe Contact, type: :model do

  describe "#validations" do
    let(:contact) { build(:contact) }
  
    it "tests that factory is valid" do
      expect(contact).to be_valid
    end
  end

  it "tests contact incorrect name" do
    contact = build(:contact)
    contact.name = 'Cristian*'
    expect(contact).to_not be_valid
  end

  it "tests contact incorrect day of birth" do
    contact = build(:contact)
    contact.dayOfBirth = '1998-100-01'
    expect(contact).to_not be_valid
  end

  it "tests contact incorrect phone" do
    contact = build(:contact)
    contact.phone = "numero"
    expect(contact).to_not be_valid
  end

  it "tests contact incorrect franchise" do
    contact = build(:contact)
    contact.phone = "1234"
    expect(contact).to_not be_valid
  end

  it "tests contact incorrect card" do
    contact = build(:contact)
    contact.card = "numero"
    expect(contact).to_not be_valid
  end

  it "tests contact incorrect email" do
    contact = build(:contact)
    contact.email = 'example.com'
  end

  it "tests contact correct name" do
    contact = build(:contact)
    contact.name = 'Cristian'
    expect(contact).to be_valid
  end

  it "tests contact correct day of birth" do
    contact = build(:contact)
    contact.dayOfBirth = '1998-10-01'
    expect(contact).to be_valid
  end

  it "tests contact correct phone" do
    contact = build(:contact)
    contact.phone = "(+00) 000 000 00 00"
    expect(contact).to be_valid
  end

  it "tests contact correct franchise" do
    contact = build(:contact)
    contact.franchise = "Visa"
    expect(contact).to be_valid
  end

  it "tests contact correct card" do
    contact = build(:contact)
    contact.card = "4111111111111111"
    expect(contact).to be_valid
  end
  
  it "tests contact correct email" do
    contact = build(:contact)
    contact.email = 'example@email.com'
  end

end
