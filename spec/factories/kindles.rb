FactoryGirl.define do
  factory :kindle do
    name { Faker::Book.title }
    code { Faker::Lorem.characters(10) }
    description { Faker::Lorem.paragraph }
    image { Faker::Avatar.image }
  end

end
