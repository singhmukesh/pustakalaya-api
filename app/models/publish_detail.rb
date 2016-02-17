class PublishDetail < ApplicationRecord
  belongs_to :item

  validates :isbn, :author, :publish_date, presence: true
end
