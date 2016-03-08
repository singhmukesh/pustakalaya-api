class V1::UsersController < V1::ApplicationController

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
  end

  # @url v1/users/top_users/
  # @action GET
  #
  # @params type [String] expected to be value of Item::ActiveRecord_Relation type attribute
  # @params number [Integer] number of users
  #
  # Return user
  #
  # @response [Json] Lease and Item details
  def top_users
    @users = User.top_users(params[:type], params[:number])
  end
end
