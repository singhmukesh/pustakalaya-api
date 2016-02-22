FactoryGirl.define do
  factory :book do
    name { Faker::Book.title }
    code { Faker::Lorem.characters(10) }
    quantity { Faker::Number.between(1, 10) }
    description { Faker::Lorem.paragraph }
    image { Faker::Avatar.image }
  end

end
