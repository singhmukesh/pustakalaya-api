class V1::UsersController < V1::ApplicationController

  def account
    @user = current_user
  end
end
