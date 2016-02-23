FactoryGirl.define do
  factory :category do
    title { Faker::Lorem.word }
  end

  trait :group_book do
    group Category.groups[:BOOK]
  end

  trait :group_device do
    group Category.groups[:DEVICE]
  end
end
