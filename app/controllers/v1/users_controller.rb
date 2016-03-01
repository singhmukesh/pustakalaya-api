class V1::UsersController < V1::ApplicationController

  # @url v1/users/leases/
  # @action GET
  #
  # Return leased by users
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
  # Return watch list of users
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
