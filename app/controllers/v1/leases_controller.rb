class V1::LeasesController < V1::ApplicationController
  after_action :lease_notification, :unwatch_book, only: :create
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

    UserMailer.delay(queue: "mailer_#{Rails.env}").lease(@lease.id)
  end

  def return_notification
    UserMailer.delay(queue: "mailer_#{Rails.env}").return(@lease.id)
  end

  def unwatch_book
    if @lease.item.type == Book.to_s
      watch_on_lease_book = current_user.watches.ACTIVE.find_by(item_id: @lease.item.id)
      watch_on_lease_book.INACTIVE! if watch_on_lease_book.present?

      UserMailer.delay(queue: "mailer_#{Rails.env}").unwatch(watch_on_lease_book.id)
    end
  end
end
