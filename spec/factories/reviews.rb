FactoryGirl.define do
  factory :review do
    description { Faker::Lorem.paragraph }
  end

end
