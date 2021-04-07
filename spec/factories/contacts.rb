FactoryBot.define do
  factory :contact do
    sequence(:name) { |n| "Juanito#{n}" }
    dayOfBirth {"1998-10-01"}
    phone {"(+57) 320 432 05 09"}
    address {"Street 7 #17-90"}
    card {'4111111111111111'}
    sequence(:email){|n| "examplecontact#{n}@example.com"}
    last_four_numbers { card.last(4) }
    association :user
    association :file_contact
  end
end
