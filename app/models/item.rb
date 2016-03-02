class Item < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :leases
  has_many :watches

  validates :name, presence: true
  validates :code, presence: true, uniqueness: {case_sensitive: false}
  validates :description, :image, presence: true

  validates :categories, presence: true

  accepts_nested_attributes_for :categories

  enum status: [:ACTIVE, :INACTIVE]

  # Filter items by category
  def self.find_by_category(category)
    includes(:categories).where(categories: {title: category})
  end
end
