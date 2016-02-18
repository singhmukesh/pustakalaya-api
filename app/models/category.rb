class Category < ApplicationRecord

  enum group: [:BOOK, :KINDLE, :DEVICE]

  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :group, presence: true
end
