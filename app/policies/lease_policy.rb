class LeasePolicy
  attr_reader :user, :lease

  def initialize(user, lease)
    @user = user
    @lease = lease
  end

  def index?
    user.ADMIN?
  end
end
