require 'rails_helper'

RSpec.describe Lease, type: :model do
  before do
    Timecop.freeze
  end

  subject { FactoryGirl.create(:lease) }

  describe 'presence' do
    it { is_expected.to validate_presence_of(:issue_date) }
    it { is_expected.to validate_presence_of(:due_date) }
    it { is_expected.to validate_absence_of(:return_date).on(:create) }
    it { is_expected.to validate_numericality_of(:renew_count).is_less_than_or_equal_to(ENV['MAX_TIME_FOR_RENEW'].to_i) }
  end

  describe 'validation issue date and due date for device lease' do
    context 'when issue date time is past' do
      it 'should be invalid' do
        lease = FactoryGirl.build(:lease, issue_date: Time.current - 1.hours)
        lease.valid?
        expect(lease.errors[:issue_date].size).to eq(1)
      end
    end

    context 'when issue date time is future date time' do
      before do
        Timecop.freeze
      end

      it 'should be valid' do
        lease = FactoryGirl.build(:lease, issue_date: Time.current + 1.hours)
        lease.valid?
        expect(lease.errors[:issue_date].size).to eq(0)
      end
    end

    context 'when due date time is past' do
      it 'should be valid' do
        lease = FactoryGirl.build(:lease, issue_date: Time.current + 1.hours, due_date: Time.current + 2.hours)
        lease.valid?
        expect(lease.errors[:due_date].size).to eq(0)
      end
    end

    context 'when due date time is future date time' do
      before do
        Timecop.freeze
      end

      it 'should be invalid' do
        lease = FactoryGirl.build(:lease, issue_date: Time.current - 2.hours, due_date: Time.current - 1.hours)
        lease.valid?
        expect(lease.errors[:due_date].size).to eq(1)
      end
    end

    context 'when due date is past date compared to issue date' do
      it 'should be raise exception CustomException::ItemUnavailable' do
        expect { FactoryGirl.create(:lease, issue_date: Time.current + 2.hours, due_date: Time.current + 1.hours) }.to raise_exception CustomException::ItemUnavailable
      end
    end

    context 'when issue date and due date have date difference more than specified' do
      it 'should be invalid' do
        lease = FactoryGirl.build(:lease, issue_date: Time.current, due_date: Time.current + (ENV['MAX_DEVICE_LEASE_DAYS'].to_i + 1).days)
        lease.valid?
        expect(lease.errors[:due_date][0]).to eq(I18n.t('validation.invalid_date'))
      end
    end
  end

  context 'when book lease request for not available book' do
    it 'should be raise exception CustomException::ItemUnavailable' do
      number_of_book = 2
      book = FactoryGirl.create(:book, quantity: number_of_book)
      FactoryGirl.create_list(:lease, number_of_book, item_id: book.id)

      expect { FactoryGirl.create(:lease, item_id: book.id) }.to raise_exception CustomException::ItemUnavailable
    end
  end

  context 'when book lease request for not available book' do
    it 'should be raise exception CustomException::ItemUnavailable' do
      number_of_device = 2
      issue_date = Time.current + 2.hours
      due_date = Time.current + 3.hours
      device = FactoryGirl.create(:device, quantity: number_of_device)
      FactoryGirl.create_list(:lease, number_of_device, item_id: device.id, issue_date: issue_date, due_date: due_date)

      expect { FactoryGirl.create(:lease, item_id: device.id, issue_date: issue_date, due_date: due_date) }.to raise_exception CustomException::ItemUnavailable
    end
  end

  context 'when item which has already been leased by ownself' do
    before do
      @device = FactoryGirl.create(:device)
      @user = FactoryGirl.create(:user)
      FactoryGirl.create(:lease, item_id: @device.id, user_id: @user.id)
    end

    it 'should be add validation error message to item_id' do
      lease = FactoryGirl.build(:lease, item_id: @device.id, user_id: @user.id)
      lease.valid?
      expect(lease.errors[:item_id][0]).to eq I18n.t('validation.already_leased')
    end
  end

  describe 'association' do
    it { is_expected.to belong_to(:item) }
    it { is_expected.to belong_to(:user) }
  end

  describe '#notify' do
    before do
      @lease = FactoryGirl.create(:lease)
    end

    context 'when watch is active' do
      it 'should sends a watch successfull email' do
        expect { @lease.notify }.to change { Sidekiq::Extensions::DelayedMailer.jobs.size }.by(1)
      end
    end

    context 'when watch is inactive' do
      before do
        @lease.update_attribute(:return_date, Time.current)
        @lease.INACTIVE!
      end

      it 'should sends a unwatch successfull email' do
        expect { @lease.notify }.to change { Sidekiq::Extensions::DelayedMailer.jobs.size }.by(1)
      end
    end
  end

  describe '#notify_to_watchers' do
    before do
      @number_of_watches = 4
      item_quantity = 1
      item = FactoryGirl.create(:book, quantity: item_quantity)
      @leases = FactoryGirl.create_list(:lease, item_quantity, item_id: item.id)
      FactoryGirl.create_list(:watch, @number_of_watches, item_id: item.id)
    end

    it 'should sends a book leased email' do
      expect { @leases.first.notify_to_watchers }.to change { Sidekiq::Extensions::DelayedMailer.jobs.size }.by(@number_of_watches)
    end
  end
end
