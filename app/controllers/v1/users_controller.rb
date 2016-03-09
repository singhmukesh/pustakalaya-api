class V1::UsersController < V1::ApplicationController

  # @url v1/users/ranking/
  # @action GET
  #
  # @params type [String] expected to be value of Item::ActiveRecord_Relation type attribute
  #
  # Return user by ranking by number of leases
  #
  # @response [Json]
  def ranking
    @users = User.top_leasers(params[:type])
    @users = paginate(@users)
  end

  # @url v1/users/info
  # @action GET
  #
  # Show current user detail
  #
  # @response [Json]
  def info
    @user = current_user
  end

  # @url v1/users/leases/
  # @action GET
  #
  # @params type [String] expected to be value of Item::ActiveRecord_Relation type attribute
  #
  # Return leased associated to current user
  #
  # @response [Json] Lease and Item details
  def leases
    @leases = current_user.leases.ACTIVE.list(params[:type])
  end

  # @url v1/users/watches/
  # @action GET
  #
  # Return watch list of current user
  #
  # @response [Json] watches and Item details
  def watches
    @watches = current_user.watches.ACTIVE
    @watches = paginate(@watches)
  end
end
