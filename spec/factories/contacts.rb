FactoryBot.define do
  factory :contact do
    sequence(:name) { |n| "Juanito_#{n}" }
    sequence(:email){|n| "examplecontact#{n}@example.com"}
    dayOfBirth {"1998-10-01"}
    phone {3468976753}
    address {"Street 7 #17-90"}
    card {'4111111111111111'}
    franchise {"Visa"}
    sequence(:email){|n| "examplecontact#{n}@example.com"}
    last_four_numbers { card.last(4) }
    association :user
  end
end
