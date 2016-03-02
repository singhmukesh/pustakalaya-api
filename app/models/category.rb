class Category < ApplicationRecord
  has_and_belongs_to_many :books

  enum group: [:BOOK, :DEVICE]

  validates :title, presence: true, uniqueness: {case_sensitive: false}
  validates :group, presence: true

  # Provides the collection of categories
  #
  # @params group [String] expected to be value of Category::ActiveRecord_Relation group attribute value
  #
  # @return [Category::ActiveRecord_Relation Collection]
  def self.list(group = nil)
    group.upcase! if group.present?
    if group == Category.groups.keys[Category.groups[:BOOK]]
      where(group: Category.groups[:BOOK])
    elsif group == Category.groups.keys[Category.groups[:DEVICE]]
      where(group: Category.groups[:DEVICE])
    else
      all
    end
  end
end
