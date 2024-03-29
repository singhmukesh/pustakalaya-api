require 'rails_helper'

RSpec.describe V1::LeasesController, type: :controller do
  let(:admin) { FactoryGirl.create(:user, :role_admin) }
  let(:device) { FactoryGirl.create(:device) }

  before do
    Timecop.freeze
    allow(controller).to receive(:authenticate_user!)
    controller.instance_variable_set(:@current_user, admin)
  end

  describe '#index' do
    let(:lease_device) { FactoryGirl.create(:lease) }
    let(:lease_book) { FactoryGirl.create(:lease, :lease_book) }
    FactoryGirl.create(:lease).INACTIVE!

    context 'when type parameter is defined' do
      before do
        get :index
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should list all ACTIVE leases to @leases' do
        expect(assigns(:leases)).to match_array [lease_book, lease_device]
      end
    end

    context 'when type parameter book' do
      before do
        get :index, params: {type: Book.to_s}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should list all ACTIVE leases of book to @leases' do
        expect(assigns(:leases)).to match_array [lease_book]
      end
    end

    context 'when type parameter device' do
      before do
        get :index, params: {type: Device.to_s}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should list all ACTIVE leases of device to @leases' do
        expect(assigns(:leases)).to match_array [lease_device]
      end
    end
  end

  describe '#create' do
    context 'when lease attributes are valid' do
      before do
        @lease_count = Lease.count
        post :create, params: {lease: FactoryGirl.attributes_for(:lease, issued_date: (Time.now + 1.hour).to_i, due_date: (Time.now + 2.hours).to_i, item_id: device.id)}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should create new Lease' do
        expect(Lease.count).to eq @lease_count + 1
      end

      it 'should have lease item as device' do
        expect(Lease.last.item.code).to eq device.code
      end
    end

    context 'when lease attributes are invalid' do
      before do
        @lease_count = Lease.count
        post :create, params: {lease: FactoryGirl.attributes_for(:lease, issued_date: Time.current - 3.days, item_id: device.id)}
      end

      it 'should respond with status unprocessable_entity' do
        is_expected.to respond_with :unprocessable_entity
      end

      it 'should not create new Lease' do
        expect(Lease.count).to eq @lease_count
      end
    end

    context 'when user has the leased book which is on watchlist' do
      let!(:book) { FactoryGirl.create(:book, quantity: 1) }
      let!(:lease) { FactoryGirl.create(:lease, item_id: book.id) }
      let!(:watch) { FactoryGirl.create(:watch, item_id: book.id, user: admin) }

      before do
        lease.update_attribute(:return_date, Time.current)
        lease.INACTIVE!

        @lease_count = Lease.count
        post :create, params: {lease: FactoryGirl.attributes_for(:lease, item_id: book.id)}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should create new Lease' do
        expect(Lease.count).to eq @lease_count + 1
      end

      it 'should have lease item as book' do
        expect(Lease.last.item.code).to eq book.code
      end

      it 'should remove book from watch list' do
        watch.reload
        expect(watch.INACTIVE?).to be_truthy
      end
    end

    context 'when unavailable item is leased' do
      let!(:book) { FactoryGirl.create(:book, quantity: 1) }
      let!(:lease) { FactoryGirl.create(:lease, item_id: book.id) }

      before do
        @lease_count = Lease.count
        post :create, params: {lease: FactoryGirl.attributes_for(:lease, item_id: book.id)}
      end

      it 'should respond with status conflict' do
        is_expected.to respond_with :conflict
      end

      it 'should not create new Lease' do
        expect(Lease.count).to eq @lease_count
      end
    end
  end

  describe '#return' do
    context 'with valid attributes' do
      before do
        @lease = FactoryGirl.create(:lease, item_id: device.id, user: admin)
        post :return, params: {id: @lease.id}
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
        lease = FactoryGirl.create(:lease, item_id: device.id, user: FactoryGirl.create(:user))
        post :return, params: {id: lease.id}
      end

      it 'should respond with status unauthorized' do
        is_expected.to respond_with :unauthorized
      end
    end
  end
end
