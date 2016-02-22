class Device < Item
  before_create :set_params

  private

  def set_params
    self.is_readable = false
    self.is_leaseable = true
    self.is_rateable = false
    self.is_reviewable = false
  end
end
