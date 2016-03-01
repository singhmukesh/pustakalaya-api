require 'rails_helper'

RSpec.describe V1::UsersController, type: :controller do

  describe '#lease' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:lease_device) { FactoryGirl.create(:lease, user: user) }
    let!(:lease_book) { FactoryGirl.create(:lease, :lease_book, user: user) }

    before do
      allow(controller).to receive(:authenticate_user!)
      controller.instance_variable_set(:@current_user, user)
    end

    context "when params 'type' is undefined" do
      before do
        post :leases
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should assign all active lease to @leases' do
        expect(assigns(:leases)).to match_array [lease_book, lease_device]
      end
    end

    context "when params 'type' value is 'book'" do
      before do
        post :leases, params: {type: Book.to_s}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should assign all active book lease to @leases' do
        expect(assigns(:leases)).to match_array [lease_book]
      end
    end

    context "when params 'type' value is 'Device'" do
      before do
        post :leases, params: {type: Device.to_s}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should assign all active device lease to @leases' do
        expect(assigns(:leases)).to match_array [lease_device]
      end
    end
  end
end
