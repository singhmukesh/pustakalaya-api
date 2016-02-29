FactoryGirl.define do
  factory :publish_detail do
    isbn { Faker::Code.isbn }
    author { Faker::Name.name }
    publish_date { Faker::Date.backward }
  end

end
