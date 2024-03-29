require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:lease) { FactoryGirl.create(:lease) }

  describe '#lease' do
    let(:mail) { UserMailer.lease(lease.id) }

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
        UserMailer.delay.lease(lease.id)
      }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end

    after do
      ActionMailer::Base.deliveries.clear
    end
  end

  describe '#return' do
    let(:mail) { UserMailer.return(lease.id) }

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
        UserMailer.delay.return(lease.id)
      }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end

    after do
      ActionMailer::Base.deliveries.clear
    end
  end

  describe '#watch' do
    before do
      book_quantity = 1
      book = FactoryGirl.create(:book, quantity: book_quantity)
      FactoryGirl.create_list(:lease, book_quantity, item_id: book.id)
      @watch =  FactoryGirl.create(:watch, item_id: book.id)
      @mail = UserMailer.watch(@watch.id)

      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eql([@watch.user.email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eql(ENV['MAILER_EMAIL'].scan(/<([^>]*)>/).first)
    end

    it 'delay the mails sending process' do
      expect {
        UserMailer.delay.watch(@watch.id)
      }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end

    after do
      ActionMailer::Base.deliveries.clear
    end
  end

  describe '#unwatch' do
    before do
      book_quantity = 1
      book = FactoryGirl.create(:book, quantity: book_quantity)
      FactoryGirl.create_list(:lease, book_quantity, item_id: book.id)
      @watch =  FactoryGirl.create(:watch, item_id: book.id)
      @mail = UserMailer.unwatch(@watch.id)

      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eql([@watch.user.email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eql(ENV['MAILER_EMAIL'].scan(/<([^>]*)>/).first)
    end

    it 'delay the mails sending process' do
      expect {
        UserMailer.delay.unwatch(@watch.id)
      }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end

    after do
      ActionMailer::Base.deliveries.clear
    end
  end

  describe '#notification_to_watchers' do
    before do
      book_quantity = 1
      book = FactoryGirl.create(:book, quantity: book_quantity)
      FactoryGirl.create_list(:lease, book_quantity, item_id: book.id)
      @watch = FactoryGirl.create(:watch, item_id: book.id)
      @mail = UserMailer.notification_to_watchers(book.leases.ACTIVE.first.id, @watch.id)
      @lease = book.leases.ACTIVE.first

      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eql([@watch.user.email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eql(ENV['MAILER_EMAIL'].scan(/<([^>]*)>/).first)
    end

    it 'delay the mails sending process' do
      expect {
        UserMailer.delay.notification_to_watchers(@lease.id, @watch.id)
      }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end

    after do
      ActionMailer::Base.deliveries.clear
    end
  end

  describe '#notify_past_due_date' do
    before do
      @lease = FactoryGirl.create(:lease, :lease_book)
      @lease.update(due_date: DateTime.now - 2.days)
      @mail = UserMailer.notify_past_due_date(@lease.id)

      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eql([@lease.user.email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eql(ENV['MAILER_EMAIL'].scan(/<([^>]*)>/).first)
    end

    it 'delay the mails sending process' do
      expect {
        UserMailer.delay.notify_past_due_date(@lease.id)
      }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end

    after do
      ActionMailer::Base.deliveries.clear
    end
  end

  describe '#notify_near_due_date' do
    before do
      @lease = FactoryGirl.create(:lease, :lease_book)
      @lease.update(due_date: DateTime.now - 2.days)
      @mail = UserMailer.notify_near_due_date(@lease.id)
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eql([@lease.user.email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eql(ENV['MAILER_EMAIL'].scan(/<([^>]*)>/).first)
    end

    it 'delay the mails sending process' do
      expect {
        UserMailer.delay.notify_near_due_date(@lease.id)
      }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end

    after do
      ActionMailer::Base.deliveries.clear
    end
  end

end
