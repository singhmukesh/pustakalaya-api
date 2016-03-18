class PublishDetail < ApplicationRecord
  belongs_to :item

  validates :author, presence: true
  validates_date :publish_date, on_or_before: lambda { Date.current }, allow_nil: true
end
