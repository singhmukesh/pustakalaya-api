FactoryGirl.define do
  factory :publish_detail do
    isbn { Faker::Code.isbn }
    author { Faker::Book.author }
    publish_date { Faker::Date.backward }
  end

end
