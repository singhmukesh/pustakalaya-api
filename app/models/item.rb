class Item < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :leases
  has_many :watches

  validates :name, presence: true
  validates :code, presence: true, uniqueness: {case_sensitive: false}
  validates :description, :image, presence: true
  # validates_inclusion_of :status, in: [0, 1]

  validates :categories, presence: true

  accepts_nested_attributes_for :categories

  enum status: [:ACTIVE, :INACTIVE]
end
