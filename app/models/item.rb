class Item < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :leases
  has_many :watches
  has_many :ratings
  has_many :reviews

  validates :name, presence: true
  validates :code, presence: true, uniqueness: {case_sensitive: false}
  validates :description, :image, presence: true

  validates :categories, presence: true

  accepts_nested_attributes_for :categories

  enum status: [:ACTIVE, :INACTIVE]

  scope :books, -> { where(type: Book.to_s) }
  scope :kindles, -> { where(type: Kindle.to_s) }
  scope :devices, -> { where(type: Device.to_s) }

  # Filter items by category
  #
  # @params category_id [Category::ActiveRecord_Relation id attribute]
  #
  # @return [Item::ActiveRecord_Relation Collection]
  def self.find_by_category(category_id)
    includes(:categories).where(categories: {id: category_id})
  end

  # Provides the overall rating value of item
  #
  # @return [Integer], Overall rating divided by count, if no any ratings are found then return -1
  def rating
    count = self.ratings.count
    return 0 if count == 0
    self.ratings.sum(:value)/count
  end

  class <<self
    # Provides whether item is rateable or not
    #
    # @params type [Item::ActiveRecord_Relation type attribute]
    #
    # @return [Boolean]
    def rateable?(type)
      case type
      when Book.to_s
        true
      when Kindle.to_s
        true
      else
        false
      end
    end

    # Provides whether item is leaseable or not
    #
    # @params type [Item::ActiveRecord_Relation type attribute]
    #
    # @return [Boolean]
    def leaseable?(type)
      case type
      when Book.to_s
        true
      when Device.to_s
        true
      else
        false
      end
    end
  end

  class << self
    # Provides the collection of most rated items
    #
    # @params type [String] expected to be value of Item::ActiveRecord_Relation type attribute
    #
    # @return [Item::ActiveRecord_Relation Collection]
    def most_rated(type = Book.to_s)
      type ||= Book.to_s
      raise ActiveRecord::StatementInvalid unless Item.rateable?(type)
      joins(:ratings).group('ratings.item_id').order('avg(ratings.value) desc').ACTIVE.where('type = ?', type)
    end

    # Provides the collection of most leased items
    #
    # @params type [String] expected to be value of Item::ActiveRecord_Relation type attribute
    #
    # @return [Item::ActiveRecord_Relation Collection]
    def most_leased(type = Book.to_s)
      type ||= Book.to_s
      raise ActiveRecord::StatementInvalid unless Item.leaseable?(type)
      self.joins(:leases).group('leases.item_id').order('count(leases.item_id) desc').ACTIVE.where('type = ?', type)
    end
  end
end
