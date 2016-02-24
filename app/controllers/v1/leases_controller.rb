class V1::LeasesController < V1::ApplicationController
  rescue_from CustomException::ItemUnavailable, with: :item_unavailable

  def create
    @lease = Lease.new(lease_params.merge!(user_id: current_user.id))
    @lease.save!
  end

  private

  def lease_params
    params.require(:lease).permit(:id, :issue_date, :due_date, :item_id)
  end

  def item_unavailable(error)
    render json: {message: error.message}, status: :conflict
  end
end
