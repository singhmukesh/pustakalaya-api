FactoryGirl.define do
  factory :watch do
    after(:build) do |lease|
      lease.item ||= FactoryGirl.build(:device)
      lease.user ||= FactoryGirl.build(:user)
    end
    after(:create) do |lease|
      lease.item.save!
      lease.user.save!
    end
  end

  trait :watch_book do
    after(:build) do |lease|
      lease.item = FactoryGirl.create(:book)
    end
  end
end
