FactoryBot.define do
  factory :contact do
    name {"Cristian - Yepes"}
    dayOfBirth {"1998-10-01"}
    phone {3468976753}
    address {"Street 7 #17-90"}
    card {'5889765490826453'}
    franchise {"Mastercard"}
    sequence(:email){|n| "examplecontact#{n}@example.com"}
    association :user
  end
end
