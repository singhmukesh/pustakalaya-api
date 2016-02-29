class V1::WatchesController < V1::ApplicationController

  def create
    @watch = current_user.watches.new(watch_params)
    @watch.save!
  end

  # @url v1/watch/unwatch
  # @action POST
  #
  # Remove Book form Watch list
  #
  # @required item_id [Integer] Id of item to be remove from watchlist
  #
  # @response [Json] Lease and Item details
  def unwatch
    @watch = Watch.ACTIVE.find_by(user_id: current_user.id, item_id: params[:item_id])
    raise CustomException::Unauthorized unless @watch.present?
    @watch.INACTIVE!
  end

  private

  def watch_params
    params.require(:watch).permit(:id, :item_id)
  end

end
