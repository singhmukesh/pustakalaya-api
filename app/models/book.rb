class Book < Item
  before_create :set_params

  private

  def set_params
    self.is_readable = true
    self.is_leaseable = true
    self.is_rateable = true
    self.is_reviewable = true
  end
end
