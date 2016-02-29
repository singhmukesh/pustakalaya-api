class UserMailer < ApplicationMailer

  # Send notification email when an item is successfully leased
  #
  # @params lease_id [Lease::ActiveRecord_Relation id attribute]
  def lease_success(lease_id)
    set_lease(lease_id)

    mail(from: ENV['MAILER_EMAIL'], to: @user.email, subject: t('user_mailer.lease_success.subject'))
  end

  # Send notification email when an item is successfully returned
  #
  # @params lease_id [Lease::ActiveRecord_Relation id attribute]
  def return_success(lease_id)
    set_lease(lease_id)

    mail(from: ENV['MAILER_EMAIL'], to: @user.email, subject: t('user_mailer.return_success.subject'))
  end

  private

  def set_lease(id)
    @lease = Lease.find(id)
    @user = @lease.user
    @item = @lease.item
  end
end
