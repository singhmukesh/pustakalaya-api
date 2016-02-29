class Lease < ApplicationRecord
  before_create :set_dates, if: :book?

  belongs_to :user
  belongs_to :item

  validates_presence_of :issue_date, :due_date, if: :device?
  validates_absence_of :return_date, on: :create
  validates_numericality_of :renew_count, less_than_or_equal_to: ENV['MAX_TIME_FOR_RENEW'].to_i
  validate :already_leased
  validate :validate_due_date, on: :create, if: :device?
  validate :book_available, on: :create, if: :book?
  validate :device_available, on: :create, if: :device?

  validates_datetime :issue_date, on_or_after: lambda { Time.current }, if: :device?
  validates_datetime :due_date, after: lambda { Time.current }, if: :device?
  validates_datetime :return_date, on_or_before: lambda { Time.current }, allow_nil: true

  enum status: [:ACTIVE, :INACTIVE, :EXTENDED]

  private

  def already_leased
    unless Lease.ACTIVE.where(item_id: item_id, user_id: user_id).blank?
      errors.add(:item_id, I18n.t('validation.already_leased'))
    end
  end

  def validate_due_date
    if (issue_date.beginning_of_day + ENV['MAX_DEVICE_LEASE_DAYS'].to_i.days) < due_date.beginning_of_day
      errors.add(:due_date, I18n.t('validation.invalid_date'))
    end
  end

  def book_available
    unless self.item.available?
      raise CustomException::ItemUnavailable
    end
  end

  def device_available
    unless self.item.available?(self.issue_date, self.due_date)
      raise CustomException::ItemUnavailable
    end
  end

  def book?
    self.item.type == :Book.to_s
  end

  def device?
    self.item.type == :Device.to_s
  end

  def set_dates
    self.issue_date = Date.current
    self.due_date = Date.current + ENV['BOOK_LEASE_DAYS'].to_i.days
    self.return_date = nil
  end
end
