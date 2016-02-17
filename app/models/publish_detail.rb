class PublishDetail < ApplicationRecord
  belongs_to :item

  validates :isbn, :author, :publish_date, presence: true
  validates_date :publish_date, on_or_before: lambda { Date.current }
end
