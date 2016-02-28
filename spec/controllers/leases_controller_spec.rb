require 'rails_helper'

RSpec.describe V1::LeasesController, type: :controller do
  let(:user) { FactoryGirl.create(:user, :role_user) }
  let(:device) { FactoryGirl.create(:device) }

  before do
    Timecop.freeze
    allow(controller).to receive(:authenticate_user!)
    controller.instance_variable_set(:@current_user, user)
  end

  describe '#create' do
    context 'when lease attributes are valid' do
      before do
        @lease_count = Lease.count
        post :create, params: {lease: FactoryGirl.attributes_for(:lease, item_id: device.id)}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should create new Lease' do
        expect(Lease.count).to eq @lease_count + 1
      end

      it 'should have lease item as book' do
        expect(Lease.last.item.code).to eq device.code
      end
    end

    context 'when lease attributes are invalid' do
      before do
        @lease_count = Lease.count
        post :create, params: {lease: FactoryGirl.attributes_for(:lease, issue_date: Time.current - 3.days, item_id: device.id)}
      end

      it 'should respond with status unprocessable_entity' do
        is_expected.to respond_with :unprocessable_entity
      end

      it 'should not create new Lease' do
        expect(Lease.count).to eq @lease_count
      end
    end
  end

  describe '#return' do
    context 'with valid attributes' do
      before do
        @lease = FactoryGirl.create(:lease, item_id: device.id, user_id: user.id)
        post :return, params: { item_id: device.id }
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should have current date time as return date' do
        @lease.reload
        expect(@lease.return_date.strftime('%A, %d %B %Y, %I:%M%p')).to eq Time.current.strftime('%A, %d %B %Y, %I:%M%p')
      end

      it 'should have status as INACTIVE' do
        @lease.reload
        expect(@lease.INACTIVE?).to be_truthy
      end
    end

    context 'with invalid attributes' do
      before do
        @lease = FactoryGirl.create(:lease, item_id: device.id, user_id: FactoryGirl.create(:user).id)
        post :return, params: { item_id: device.id }
      end

      it 'should respond with status unauthorized' do
        is_expected.to respond_with :unauthorized
      end
    end
  end
end
