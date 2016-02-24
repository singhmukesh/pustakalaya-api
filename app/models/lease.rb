class Lease < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates_presence_of :issue_date, :due_date, on: :create
  validates_absence_of :issue_date, :due_date, on: :update
  validates_absence_of :return_date, on: :create
  validates_numericality_of :renew_count, less_than_or_equal_to: ENV['MAX_TIME_FOR_RENEW'].to_i
  validate :validate_due_date, on: :create

  validates_datetime :issue_date, on_or_after: lambda { Time.current }
  validates_datetime :due_date, after: lambda { Time.current }
  validates_datetime :return_date, on_or_before: lambda { Time.current }, allow_nil: true

  enum status: [:ACTIVE, :INACTIVE, :EXTENDED]

  private

  def validate_due_date
    if self.item.type == :Device.to_s
      if issue_date > due_date || (issue_date.beginning_of_day + ENV['MAX_DEVICE_LEASE_DAYS'].to_i.days) < due_date.beginning_of_day
        errors.add(:due_date, I18n.t('validation.invalid_date'))
      end
    end
  end
end
