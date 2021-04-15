require 'rails_helper'

RSpec.describe User, type: :model do
  it "tests user object" do
    user = FactoryBot.create(:user)
    expect(user.password).to eq('Sample-password')
    expect(user.email).to eq('example1@example.com')
  end

  it "tests user email" do
    user = build(:user)
    user.email = 'Cristian'
    expect(user).to_not be_valid
  end

  it "tests user password" do
    user = build(:user)
    user.password = '123'
    expect(user).to_not be_valid
  end

  it "tests user correct email" do
    user = build(:user)
    user.email = 'example@email.com'
    expect(user).to be_valid
  end

  it "tests user correct password" do
    user = build(:user)
    user.password = '12345678'
    expect(user).to be_valid
  end

end
