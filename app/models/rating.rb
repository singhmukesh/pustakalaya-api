class Rating < ApplicationRecord
  UPPER_BOUND = 5

  belongs_to :user
  belongs_to :item

  validates :value, numericality: {less_than_or_equal_to: UPPER_BOUND, greater_than: 0}
  validates :item_id, uniqueness: {scope: :user_id}
end
