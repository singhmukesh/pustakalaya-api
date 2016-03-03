class Review < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :description, presence: true
  validates :item_id, uniqueness: {scope: :user_id}
  validate :reviewable

  private

  def reviewable
    unless Item.find(self.item_id).is_reviewable
      errors.add(:item_id, I18n.t('validation.item_not_reviewable'))
    end
  end
end
