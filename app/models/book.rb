class Book < Item
  before_create :set_params

  has_many :leases, foreign_key: :item_id
  has_one :publish_detail, foreign_key: :item_id, inverse_of: :item

  validates :publish_detail, presence: true

  accepts_nested_attributes_for :publish_detail

  def available?
    self.leases.ACTIVE.count < self.quantity
  end

  private

  def set_params
    self.is_readable = true
    self.is_leaseable = true
    self.is_rateable = true
    self.is_reviewable = true
  end
end
