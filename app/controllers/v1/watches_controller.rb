class V1::WatchesController < V1::ApplicationController

  def create
    @watch = Watch.new(watch_params.merge!(user_id: current_user.id))
    @watch.save!
  end

  def unwatch
    @watch = Watch.find_by(item_id: params[:item_id])
    @watch.INACTIVE!
  end

  private

  def watch_params
    params.require(:watch).permit(:id, :item_id)
  end

end
