FactoryGirl.define do
  factory :device do
    name { Faker::Commerce.product_name }
    code { Faker::Lorem.characters(10) }
    quantity { Faker::Number.between(1, 10) }
    description { Faker::Lorem.paragraph }
    image { Faker::Avatar.image }
    type Device.to_s
    after(:build) do |device|
      device.categories << FactoryGirl.build(:category, :group_device)
    end
    after(:create) do |device|
      device.categories.each { |category| category.save! }
    end
  end

end
