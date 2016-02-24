FactoryGirl.define do
  factory :lease do
    issue_date { Time.current + 2.hours }
    due_date { Time.current + 4.days }
    after(:build) do |lease|
      lease.item ||= FactoryGirl.build(:device)
      lease.user ||= FactoryGirl.build(:user, :role_user)
    end
    after(:create) do |lease|
      lease.item.save!
      lease.user.save!
    end
  end

  trait :device_book do
    after(:build) do |lease|
      lease.item = FactoryGirl.create(:book)
    end
  end
end
