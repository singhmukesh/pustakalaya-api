class Watch < ApplicationRecord
  belongs_to :item
  belongs_to :user

  enum status: [:ACTIVE, :INACTIVE]
end
