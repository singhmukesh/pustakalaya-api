class UserMailer < ApplicationMailer

  # Send notification email when an item is successfully leased
  #
  # @params user_id [User::ActiveRecord_Relation id attribute], user id who successfully leased item
  # @params item_id [Item::ActiveRecord_Relation id attribute], item id which is being leased
  def lease_success(lease_id)
    @lease = Lease.find(lease_id)
    @user = @lease.user
    @item = @lease.item

    mail(from: ENV['MAILER_EMAIL'], to: @user.email, subject: t('user_mailer.lease_success.subject'))
  end
end
