class Kindle < Item
  before_create :set_params

  has_one :publish_detail, foreign_key: :item_id

  private

  def set_params
    self.is_readable = true
    self.is_leaseable = false
    self.is_rateable = true
    self.is_reviewable = true
  end
end
