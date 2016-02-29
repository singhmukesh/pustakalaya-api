class V1::LeasesController < V1::ApplicationController
  after_action :lease_notification, only: :create
  after_action :return_notification, only: :return
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
    @lease = Lease.ACTIVE.find_by(user_id: current_user.id, item_id: params[:item_id])
    raise CustomException::Unauthorized unless @lease.present?
    @lease.update_attribute(:return_date, Time.current)
    @lease.INACTIVE!
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

  def return_notification
    UserMailer.delay(queue: "mailer_#{Rails.env}").return_success(@lease.id)
  end
end
