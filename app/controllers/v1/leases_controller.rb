class V1::LeasesController < V1::ApplicationController

  def create
    @lease = Lease.new(lease_params)
    @lease.save!
  end

  private

  def lease_params
    params.require(:lease).permit(:id, :issue_date, :due_date, :item_id)
  end
end
