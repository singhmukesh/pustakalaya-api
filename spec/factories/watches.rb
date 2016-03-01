FactoryGirl.define do
  factory :watch do
    after(:build) do |lease|
      lease.item ||= FactoryGirl.build(:book)
      lease.user ||= FactoryGirl.build(:user)
    end
    after(:create) do |lease|
      lease.item.save!
      lease.user.save!
    end
  end
end
