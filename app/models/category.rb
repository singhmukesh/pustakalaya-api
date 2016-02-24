class Category < ApplicationRecord
  has_and_belongs_to_many :books

  enum group: [:BOOK, :DEVICE]

  validates :title, presence: true, uniqueness: {case_sensitive: false}
  validates :group, presence: true
end
