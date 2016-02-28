FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    uid { Faker::Lorem.characters }
  end

  trait :role_admin do
    role { User.roles[:ADMIN] }
  end
end
