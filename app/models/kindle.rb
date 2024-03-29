class Kindle < Item
  before_create :set_params

  has_one :publish_detail, foreign_key: :item_id, inverse_of: :item

  validates :publish_detail, presence: true

  accepts_nested_attributes_for :publish_detail

  private

  def set_params
    self.is_readable = true
    self.is_leaseable = false
    self.is_rateable = true
  end
end
