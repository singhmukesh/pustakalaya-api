FactoryGirl.define do
  factory :rating do
    value { Faker::Number.between(1, Rating::UPPER_BOUND) }
    after(:build) do |rating|
      rating.item ||= FactoryGirl.build(:book)
      rating.user ||= FactoryGirl.build(:user)
    end
    after(:create) do |rating|
      rating.item.save!
      rating.user.save!
    end
  end

end
