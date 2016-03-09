class ItemPolicy
  attr_reader :user, :item

  def initialize(user, item)
    @user = user
    @item = item
  end

  def create?
    user.ADMIN?
  end

  def change_status?
    user.ADMIN?
  end

  def leased?
    user.ADMIN?
  end
end
