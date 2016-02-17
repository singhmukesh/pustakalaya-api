class Item < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: {case_sensitive: false}
  validates :description, :image, presence: true

  enum status: [:ACTIVE, :INACTIVE]
end
