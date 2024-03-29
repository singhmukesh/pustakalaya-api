FactoryGirl.define do
  factory :book do
    name { Faker::Book.title }
    code { Faker::Lorem.characters(10) }
    quantity { Faker::Number.between(1, 10) }
    description { Faker::Lorem.paragraph }
    image { Faker::Avatar.image }
    type Book.to_s
    after(:build) do |book|
      book.publish_detail ||= FactoryGirl.build(:publish_detail)
      book.categories << FactoryGirl.build(:category, :group_book)
    end
    after(:create) do |book|
      book.publish_detail.save!
      book.categories.each { |category| category.save! }
    end
  end

end
