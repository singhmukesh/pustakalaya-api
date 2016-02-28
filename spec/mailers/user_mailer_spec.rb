require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let!(:lease) { FactoryGirl.create(:lease) }

  describe '#lease_success' do
    let(:mail) { UserMailer.lease_success(lease.id) }

    before do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([lease.user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(ENV['MAILER_EMAIL'].scan(/<([^>]*)>/).first)
    end

    it 'delay the mails sending process' do
      expect {
        UserMailer.delay.lease_success(lease.id)
      }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end

    after do
      ActionMailer::Base.deliveries.clear
    end
  end

  describe '#return_success' do
    let(:mail) { UserMailer.return_success(lease.id) }

    before do
      lease.update_attribute(:return_date, Time.current)
      lease.INACTIVE!
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([lease.user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(ENV['MAILER_EMAIL'].scan(/<([^>]*)>/).first)
    end

    it 'delay the mails sending process' do
      expect {
        UserMailer.delay.return_success(lease.id)
      }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end

    after do
      ActionMailer::Base.deliveries.clear
    end
  end
end
