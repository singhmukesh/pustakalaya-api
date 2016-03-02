class Item < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :leases
  has_many :watches
  has_many :ratings

  validates :name, presence: true
  validates :code, presence: true, uniqueness: {case_sensitive: false}
  validates :description, :image, presence: true

  validates :categories, presence: true

  accepts_nested_attributes_for :categories

  enum status: [:ACTIVE, :INACTIVE]

  # Filter items by category
  #
  # @params category_id [Category::ActiveRecord_Relation id attribute]
  #
  # @return [Item::ActiveRecord_Relation Collection]
  def self.find_by_category(category_id)
    includes(:categories).where(categories: {id: category_id})
  end
end
