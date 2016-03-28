class ItemPolicy
  attr_reader :user, :item

  def initialize(user, item)
    @user = user
    @item = item
  end

  def create?
    user.ADMIN?
  end

  def status?
    user.ADMIN?
  end
end
