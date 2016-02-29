class V1::LeasesController < V1::ApplicationController
  after_action :lease_notification, only: :create
  rescue_from CustomException::ItemUnavailable, with: :item_unavailable

  def create
    @lease = current_user.leases.new(lease_params)
    @lease.save!
  end

  private

  def lease_params
    params.require(:lease).permit(:id, :issue_date, :due_date, :item_id)
  end

  def item_unavailable(error)
    render json: {message: error.message}, status: :conflict
  end

  def lease_notification
    UserMailer.delay(queue: "mailer_#{Rails.env}").lease_success(@lease.id)
  end
end
