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
  # Return leased associated to current user
  #
  # @response [Json] Lease and Item details
  def leases
    @leases = if type == Book.to_s
                current_user.leases.ACTIVE.books
              elsif type == Device.to_s
                current_user.leases.ACTIVE.devices
              else
                current_user.leases.ACTIVE
              end
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

  private

  def type
    params[:type].capitalize if params[:type].present?
  end
end
