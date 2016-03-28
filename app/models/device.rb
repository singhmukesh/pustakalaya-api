class Device < Item
  before_create :set_params

  has_many :leases, foreign_key: :item_id

  # Check if the device is available for lease
  #
  # @params issued_date [DateTime] starting time of availability
  # @params due_date [DateTime] ending time of availability
  #
  # @return[Boolean]
  def available?(issued_date, due_date)
    return false if issued_date > due_date

    leases = self.leases.ACTIVE
    count = 0

    if leases.present?
      leases.each do |lease|
        if (issued_date >= lease.issued_date && issued_date < lease.due_date) || (due_date <= lease.due_date && due_date > lease.issued_date)
          count = count + 1
        end
      end
    end

    unless count < self.quantity
      return false
    end

    true
  end

  private

  def set_params
    self.is_readable = false
    self.is_leaseable = true
    self.is_rateable = false
  end
end
