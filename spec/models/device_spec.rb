require 'rails_helper'

RSpec.describe Device, type: :model do
  before do
    Timecop.freeze
  end
  subject {FactoryGirl.build(:device)}

  describe 'uniqueness' do
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
  end

  describe 'association' do
    it { is_expected.to have_many(:leases).with_foreign_key(:item_id) }
  end

  describe '#available?' do
    before do
      @device_quantity = 2
      @device = FactoryGirl.create(:device, quantity: @device_quantity)
      @issued_date =  Time.current + 3.hours
      @due_date = Time.current + 5.hours
    end

    context 'when no any previous lease are made' do
      it 'should return true' do
        expect(@device.available?(@issued_date, @due_date)).to be_truthy
      end
    end

    context 'when previous lease are made but not for the requested time' do
      it 'should return true' do
        FactoryGirl.create_list(:lease, @device_quantity, issued_date: @issued_date - 1.hours, due_date: @issued_date, item_id: @device.id)
        expect(@device.available?(@issued_date, @due_date)).to be_truthy
      end
    end

    context 'when their are previous leases is the requested time but less that quantity' do
      it 'should return true' do
        FactoryGirl.create_list(:lease, @device_quantity -1, issued_date: @issued_date, due_date: @due_date, item_id: @device.id)
        expect(@device.available?(@issued_date, @due_date)).to be_truthy
      end
    end

    context 'when their are previous lease is the requested time upto device quantity' do
      it 'should return false' do
        FactoryGirl.create_list(:lease, @device_quantity, issued_date: @issued_date, due_date: @due_date, item_id: @device.id)
        expect(@device.available?(@issued_date, @due_date)).to be_falsey
      end
    end

    context 'when their are previous lease upto device quantity but not complete time frame' do
      it 'should return true' do
        FactoryGirl.create_list(:lease, @device_quantity - 1, issued_date: @issued_date, due_date: @due_date, item_id: @device.id)
        FactoryGirl.create(:lease, issued_date: @issued_date, due_date: @due_date - 1.hours, item_id: @device.id)
        expect(@device.available?(@due_date - 1.hours, @due_date)).to be_truthy
      end
    end
  end
end
