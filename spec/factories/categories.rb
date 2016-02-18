FactoryGirl.define do
  factory :category do
    title { Faker::Lorem.word }
    group Category.groups[:BOOK]
  end

end
