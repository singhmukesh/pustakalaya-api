class Lease < ApplicationRecord
  before_create :set_dates, if: :book?

  belongs_to :user
  belongs_to :item

  validate :item_active, on: :create
  validates_presence_of :issue_date, :due_date, if: :device?
  validates_absence_of :return_date, on: :create
  validates_numericality_of :renew_count, less_than_or_equal_to: ENV['MAX_TIME_FOR_RENEW'].to_i
  validate :already_leased, on: :create
  validate :validate_due_date, on: :create, if: :device?
  validate :book_available, on: :create, if: :book?
  validate :device_available, on: :create, if: :device?

  validates_datetime :issue_date, on_or_after: lambda { Time.current }, if: :device?
  validates_datetime :due_date, after: lambda { Time.current }, if: :device?
  validates_datetime :return_date, on_or_before: lambda { Time.current }, allow_nil: true

  enum status: [:ACTIVE, :INACTIVE, :EXTENDED]

  # Notify user with email when item is leased or return
  def notify
    if self.ACTIVE?
      UserMailer.delay(queue: "mailer_#{Rails.env}").lease(self.id)
    else
      UserMailer.delay(queue: "mailer_#{Rails.env}").return(self.id)
    end
  end

  # Notify to Book watchers when the book is leased or return
  def notify_to_watchers
    if self.item.type == Book.to_s
      self.item.watches.ACTIVE.each do |watch|
        UserMailer.delay(queue: "mailer_#{Rails.env}").notification_to_watchers(self.id, watch.id)
      end
    end
  end

  class << self
    # Provides the collection of Lease of books
    #
    # @return [Lease::ActiveRecord_Relation Collection]
    def books
      includes(:item).where(items: {type: Book.to_s})
    end

    # Provides the collection of Lease of devices
    #
    # @return [Lease::ActiveRecord_Relation Collection]
    def devices
      includes(:item).where(items: {type: Device.to_s})
    end

    # Provides the collection of leases
    #
    # @params group [String] expected to be value of Item::ActiveRecord_Relation type attribute value
    #
    # @return [Category::ActiveRecord_Relation Collection
    def list(type = nil)
      type.capitalize! if type.present?
      if type == Book.to_s
        books
      elsif type == Device.to_s
        devices
      else
        all
      end
    end
  end

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

  def item_active
    unless self.item.ACTIVE?
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
