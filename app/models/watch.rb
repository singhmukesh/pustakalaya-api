class Watch < ApplicationRecord
  belongs_to :item
  belongs_to :user

  enum status: [:ACTIVE, :INACTIVE]

  validate :watchable, on: :create

  private

  def watchable
    if Lease.ACTIVE.where(item_id: item_id, user_id: user_id).exists?
      errors.add(:item_id, I18n.t('validation.already_leased'))
    elsif Watch.ACTIVE.where(item_id: item_id, user_id: user_id).exists?
      errors.add(:item_id, I18n.t('validation.already_watched'))
    elsif self.item.available?
      errors.add(:item_id, I18n.t('validation.available_to_lease'))
    end
  end
end
