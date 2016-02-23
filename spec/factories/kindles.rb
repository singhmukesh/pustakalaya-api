FactoryGirl.define do
  factory :kindle do
    name { Faker::Book.title }
    code { Faker::Lorem.characters(10) }
    description { Faker::Lorem.paragraph }
    image { Faker::Avatar.image }
    type 'Kindle'
    after(:build) do |kindle|
      kindle.publish_detail ||= FactoryGirl.build(:publish_detail)
      kindle.categories << FactoryGirl.build(:category, :group_book)
    end
    after(:create) do |kindle|
      kindle.publish_detail.save!
      kindle.categories.each { |category| category.save! }
    end
  end

end
