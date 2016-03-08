require 'rails_helper'

RSpec.describe V1::UsersController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  before do
    allow(controller).to receive(:authenticate_user!)
    controller.instance_variable_set(:@current_user, user)
  end

  describe '#info' do
    before do
      get :info
    end

    it 'should respond with status ok' do
      is_expected.to respond_with :ok
    end

    it 'should assign user to @user' do
      expect(assigns(:user)).to eq user
    end
  end

  describe '#lease' do
    let!(:lease_device) { FactoryGirl.create(:lease, user: user) }
    let!(:lease_book) { FactoryGirl.create(:lease, :lease_book, user: user) }

    context "when params 'type' is undefined" do
      before do
        get :leases
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
        get :leases, params: {type: Book.to_s}
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
        get :leases, params: {type: Device.to_s}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should assign all active device lease to @leases' do
        expect(assigns(:leases)).to match_array [lease_device]
      end
    end
  end

  describe '#watches' do
    before do
      book1_quantity = 1
      book1 = FactoryGirl.create(:book, quantity: book1_quantity)
      FactoryGirl.create_list(:lease, book1_quantity, item: book1)
      @watch1 = FactoryGirl.create(:watch, item: book1, user: user)

      book2_quantity = 1
      book2 = FactoryGirl.create(:book, quantity: book2_quantity)
      FactoryGirl.create_list(:lease, book2_quantity, item: book2)
      @watch2 = FactoryGirl.create(:watch, item: book2, user: user)

      get :watches
    end

    it 'should respond with status ok' do
      is_expected.to respond_with :ok
    end

    it 'should assign all active watches to @watches' do
      expect(assigns(:watches)).to match_array [@watch1, @watch2]
    end
  end

  describe '#top_users' do
    before do
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @user3 = FactoryGirl.create(:user)

      FactoryGirl.create_list(:lease, 3, user: @user1)
      FactoryGirl.create_list(:lease, 2, user: @user2)
      FactoryGirl.create(:lease, user: @user3)

      FactoryGirl.create(:lease, :lease_book, user: @user1)
      FactoryGirl.create_list(:lease, 2, :lease_book, user: @user2)
    end

    context 'when valid parameters are send' do
      before do
        get :top_users, params: {type: Device.to_s, number: 2}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should provide top user of Device' do
        expect(assigns(:users)).to match_array [@user1, @user2]
      end
    end

    context 'when invalid parameter is send' do
      before do
        get :top_users, params: {type: Faker::Lorem.word}
      end

      it 'should respond with status unprocessable_entity' do
        is_expected.to respond_with :unprocessable_entity
      end
    end
  end
end
