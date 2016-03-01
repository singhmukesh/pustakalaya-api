class V1::UsersController < V1::ApplicationController

  def leases
    @leases = current_user.leases
  end
end
