require 'rails_helper'

RSpec.describe Contact, type: :model do
   
  it "tests contact name" do
    contact = build(:contact)
    expect(contact.name).to eq('Cristian - Yepes')
  end

  it "tests contact day of birth" do
    contact = build(:contact)
    expect(contact.dayOfBirth).to eq('1998-10-01')
  end

  it "tests contact phone" do
    contact = build(:contact)
    expect(contact.phone).to eq(3468976753)
  end
  
  it "tests contact address" do
    contact = build(:contact)
    expect(contact.address).to eq('Street 7 #17-90')
  end

  it "tests contact card" do
    contact = build(:contact)
    expect(contact.card).to eq('5889765490826453')
  end

  it "tests contact franchise" do
    contact = build(:contact)
    expect(contact.franchise).to eq('Mastercard')
  end
  
  it "tests contact email" do
    contact = build(:contact)
    expect(contact.email).to eq('examplecontact7@example.com')
  end
end
