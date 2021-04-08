require 'rails_helper'

RSpec.describe User, type: :model do
  it "tests user object" do
    user = FactoryBot.create(:user)
    expect(user.email).to eq('cdyepes@email.com')
    expect(user.password).to eq('Sample-password')
  end

end
