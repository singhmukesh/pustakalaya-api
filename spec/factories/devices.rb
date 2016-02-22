FactoryGirl.define do
  factory :device do
    name { Faker::Commerce.product_name }
    code { Faker::Lorem.characters(10) }
    quantity { Faker::Number.between(1, 10) }
    description { Faker::Lorem.paragraph }
    image { Faker::Avatar.image }
  end

end
