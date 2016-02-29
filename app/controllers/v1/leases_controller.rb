class V1::LeasesController < V1::ApplicationController
  after_action :notify, :notification_to_watchers
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

  def notify
    @lease.notify
  end

  def unwatch_book
    if @lease.item.type == Book.to_s
      watch_on_lease_book = current_user.watches.ACTIVE.find_by(item_id: @lease.item.id)

      if watch_on_lease_book.present?
        watch_on_lease_book.INACTIVE!
        UserMailer.delay(queue: "mailer_#{Rails.env}").unwatch(watch_on_lease_book.id)
      end
    end
  end

  def notification_to_watchers
    if @lease.item.type == Book.to_s
      watches.each do |watch|
        UserMailer.delay(queue: "mailer_#{Rails.env}").notification_to_watchers(@lease.id, watch.id)
      end
    end
  end

  def watches
    @lease.item.watches.ACTIVE
  end
end
