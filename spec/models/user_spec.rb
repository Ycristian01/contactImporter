require 'rails_helper'

RSpec.describe User, type: :model do
  it "tests user object" do
    user = FactoryBot.create(:user)
    expect(user.password).to eq('Sample-password')
    expect(user.email).to eq('example1@example.com')
  end

end
