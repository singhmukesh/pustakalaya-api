class Device < Item
  before_create :set_params

  has_many :leases, foreign_key: :item_id

  private

  def set_params
    self.is_readable = false
    self.is_leaseable = true
    self.is_rateable = false
    self.is_reviewable = false
  end
end
