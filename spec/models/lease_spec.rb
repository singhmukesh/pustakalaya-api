require 'rails_helper'

RSpec.describe Lease, type: :model do
  before do
    Timecop.freeze
  end

  subject { FactoryGirl.create(:lease) }

  describe 'presence' do
    it { expect(FactoryGirl.build(:lease)).to validate_presence_of(:issue_date).on(:create) }
    it { is_expected.to validate_presence_of(:due_date).on(:create) }
    it { is_expected.to validate_absence_of(:return_date).on(:create) }
    it { is_expected.to validate_absence_of(:issue_date).on(:update) }
    it { is_expected.to validate_absence_of(:due_date).on(:update) }
    it { is_expected.to validate_numericality_of(:renew_count).is_less_than_or_equal_to(ENV['MAX_TIME_FOR_RENEW'].to_i) }
  end

  describe 'validation issue date' do
    context 'when date time is past' do
      it 'should be invalid' do
        lease = FactoryGirl.build(:lease, issue_date: Time.current - 1.hours)
        lease.valid?
        expect(lease.errors[:issue_date].size).to eq(1)
      end
    end

    context 'when date time is future date time' do
      before do
        Timecop.freeze
      end

      it 'should be valid' do
        lease = FactoryGirl.build(:lease, issue_date: Time.current + 1.hours)
        lease.valid?
        expect(lease.errors[:issue_date].size).to eq(0)
      end
    end
  end

  describe 'validation due date' do
    context 'when date time is past' do
      it 'should be invalid' do
        lease = FactoryGirl.build(:lease, due_date: Time.current - 1.hours)
        lease.valid?
        expect(lease.errors[:due_date].size).to eq(1)
      end
    end

    context 'when date time is future date time' do

      it 'should be valid' do
        lease = FactoryGirl.build(:lease, due_date: Time.current + 1.hours)
        lease.valid?
        expect(lease.errors[:due_date].size).to eq(0)
      end
    end

    context 'when item is device' do
      context 'when due date is past date compared to issue date' do
        it 'should be invalid' do
          lease = FactoryGirl.build(:lease, issue_date: Time.current + 2.hours, due_date: Time.current + 1.hours, item_id: FactoryGirl.create(:device).id)
          lease.valid?
          expect(lease.errors[:due_date][0]).to eq(I18n.t('validation.invalid_date'))
        end
      end

      context 'when issue date and due date have date difference more than specified' do
        it 'should be invalid' do
          lease = FactoryGirl.build(:lease, issue_date: Time.current, due_date: Time.current + (ENV['MAX_DEVICE_LEASE_DAYS'].to_i + 1).days, item_id: FactoryGirl.create(:device).id)
          lease.valid?
          expect(lease.errors[:due_date][0]).to eq(I18n.t('validation.invalid_date'))
        end
      end
    end
  end

  describe 'validation return date' do
    context 'when date time is past' do
      it 'should be valid' do
        lease = FactoryGirl.build(:lease, due_date: Time.current + 1.hours)
        lease.valid?
        expect(lease.errors[:due_date].size).to eq(0)
      end
    end

    context 'when date time is future date time' do
      before do
        Timecop.freeze
      end

      it 'should be invalid' do
        lease = FactoryGirl.build(:lease, due_date: Time.current - 1.hours)
        lease.valid?
        expect(lease.errors[:due_date].size).to eq(1)
      end
    end
  end

  describe 'association' do
    it { is_expected.to belong_to(:item) }
    it { is_expected.to belong_to(:user) }
  end
end
