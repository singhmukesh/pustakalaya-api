class V1::LeasesController < V1::ApplicationController
  after_action :notify
  after_action :unwatch_book, only: :create
  rescue_from CustomException::ItemUnavailable, with: :item_unavailable

  def create
    @lease = current_user.leases.new(lease_params)
    @lease.save!
  end

  # @url v1/leases/return
  # @action POST
  #
  # Return leased item
  #
  # @required item_id [Integer] Id of item to be returned
  #
  # @response [Json] Lease and Item details
  def return
    @lease = Lease.ACTIVE.find(params[:id])
    raise CustomException::Unauthorized unless @lease.user == current_user
    @lease.update({return_date: Time.current})
    @lease.INACTIVE!
  end

  private

  def lease_params
    params.require(:lease).permit(:id, :issue_date, :due_date, :item_id)
  end

  def item_unavailable(error)
    render json: {message: error.message}, status: :conflict
  end

  def notify
    @lease.notify
    @lease.notify_to_watchers
  end

  def unwatch_book
    item = @lease.item

    if item.type == Book.to_s
      item.unwatch(current_user.id)
    end
  end
end
