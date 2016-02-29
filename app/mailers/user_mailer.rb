class UserMailer < ApplicationMailer

  # Send notification email when an item is successfully leased
  #
  # @params lease_id [Lease::ActiveRecord_Relation id attribute]
  def lease(lease_id)
    set_lease(lease_id)

    mail(from: ENV['MAILER_EMAIL'], to: @user.email, subject: t('user_mailer.lease.subject'))
  end

  # Send notification email when an item is successfully returned
  #
  # @params lease_id [Lease::ActiveRecord_Relation id attribute]
  def return(lease_id)
    set_lease(lease_id)

    mail(from: ENV['MAILER_EMAIL'], to: @user.email, subject: t('user_mailer.return.subject'))
  end

  # Send notification email when a Book is successfully added to watchlist
  #
  # @params watch_id [Watch::ActiveRecord_Relation id attribute]
  def watch(watch_id)
    set_watch(watch_id)

    mail(from: ENV['MAILER_EMAIL'], to: @user.email, subject: t('user_mailer.watch.subject'))
  end

  # Send notification email when a Book is successfully remove from watchlist
  #
  # @params watch_id [Watch::ActiveRecord_Relation id attribute]
  def unwatch(watch_id)
    set_watch(watch_id)

    mail(from: ENV['MAILER_EMAIL'], to: @user.email, subject: t('user_mailer.unwatch.subject'))
  end

  private

  def set_lease(id)
    @lease = Lease.find(id)
    @user = @lease.user
    @item = @lease.item
  end

  def set_watch(id)
    watch = Watch.find(id)
    @user = watch.user
    @book = watch.item
  end
end
