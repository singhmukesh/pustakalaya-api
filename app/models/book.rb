class Book < Item
  before_create :set_params

  has_many :leases, foreign_key: :item_id
  has_one :publish_detail, foreign_key: :item_id, inverse_of: :item

  validates :publish_detail, presence: true

  accepts_nested_attributes_for :publish_detail

  # Provides whether a book is available to lease
  #
  # @return [Boolean]
  def available?
    self.ACTIVE? && (self.leases.ACTIVE.count < self.quantity)
  end

  # Provides the collection of available books
  #
  # @return [Book::ActiveRecord_Relation Collection]
  def self.available
    select('*, IFNULL(c,0) co').joins('LEFT OUTER JOIN (select item_id, count(*) c from leases where status=0 GROUP BY item_id) AS a ON a.item_id=items.id').having('quantity>co').having(status: 0)
  end

  # Remove the book form Watchlist of a user
  #
  # @params user_id [User::ActiveRecord_Relation id attribute]
  def unwatch(user_id)
    watch = self.watches.ACTIVE.find_by(user_id: user_id)

    if watch.present?
      watch.INACTIVE!
      UserMailer.delay(queue: "mailer_#{Rails.env}").unwatch(watch.id)
    end
  end

  private

  def set_params
    self.is_readable = true
    self.is_leaseable = true
    self.is_rateable = true
    self.is_reviewable = true
  end

end
