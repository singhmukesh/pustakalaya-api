class UserMailer < ApplicationMailer

  # Send reset password mail to Admin when admin is created
  #
  # @params admin_id [Admin::ActiveRecord_Relation id attribute]
  def password_change(id)
    @user = User.find(id)
    @heading = t('user_mailer.password_change.subject')

    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/vayooex-logo.png")

    mail(from: ENV['MAILER_EMAIL'], to: @user.email, subject: t('user_mailer.password_change.subject'))
  end
end
