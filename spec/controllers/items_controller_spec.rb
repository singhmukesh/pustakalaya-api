require 'rails_helper'

RSpec.describe V1::ItemsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :role_admin) }
  let(:category) { FactoryGirl.create(:category, :group_book) }
  let!(:book) { FactoryGirl.create(:book) }

  before do
    allow(controller).to receive(:authenticate_user!)
    controller.instance_variable_set(:@current_user, admin)
  end

  describe '#index' do
    context 'when params type is book' do
      before do
        FactoryGirl.create_list(:book, 12)
      end
      context 'without params' do
        before do
          get :index, type: Book.to_s
        end

        it { is_expected.to respond_with :ok }
        it 'should list default number of books' do
          expect(assigns(:items)).to match_array Book.ACTIVE.order('created_at DESC').limit(WillPaginate.per_page)
        end
      end

      context 'with pagination' do
        context 'with per page value in first page' do
          let(:page) { 1 }
          let(:per_page) { 3 }

          before do
            get :index, type: Book.to_s, page: page, per_page: per_page
          end

          it { is_expected.to respond_with :ok }
          it 'assigns the last three books to @items' do
            expect(assigns(:items)).to match_array Book.ACTIVE.order('created_at DESC').limit(3)
          end
        end
      end
    end

    context 'when param type is not defined' do
      before do
        FactoryGirl.create_list(:book, 2)
        FactoryGirl.create_list(:kindle, 3)
        FactoryGirl.create_list(:device, 1)
        get :index
      end

      it { is_expected.to respond_with :ok }
      it 'should list default number of items' do
        expect(assigns(:items)).to match_array Item.ACTIVE.order('created_at DESC').limit(WillPaginate.per_page)
      end
    end
  end

  describe '#inactivated' do
    FactoryGirl.create_list(:book, 3)
    FactoryGirl.create(:device)
    FactoryGirl.create(:kindle)
    let!(:inactive_book) { FactoryGirl.create(:book, status: Item.statuses[:INACTIVE]) }
    let!(:inactive_kindle1) { FactoryGirl.create(:kindle, status: Item.statuses[:INACTIVE]) }
    let!(:inactive_kindle2) { FactoryGirl.create(:kindle, status: Item.statuses[:INACTIVE]) }
    let!(:inactive_device) { FactoryGirl.create(:device, status: Item.statuses[:INACTIVE]) }

    context 'when param type is not defined' do
      before do
        get :inactivated
      end

      it { is_expected.to respond_with :ok }
      it 'should provides list of inactive items' do
        expect(assigns(:items)).to match_array [inactive_book, inactive_kindle1, inactive_kindle2, inactive_device]
      end
    end

    context 'when param type is kindle' do
      before do
        get :inactivated, type: Kindle.to_s
      end

      it { is_expected.to respond_with :ok }
      it 'should provides list of inactive kindles' do
        expect(assigns(:items)).to match_array [inactive_kindle1, inactive_kindle2]
      end
    end

    context 'when param type is device' do
      before do
        get :inactivated, type: Device.to_s
      end

      it { is_expected.to respond_with :ok }
      it 'should provides list of inactive devices' do
        expect(assigns(:items)).to match_array [inactive_device]
      end
    end
  end

  describe '#create' do
    context 'when the user is not admin' do
      before do
        controller.instance_variable_set(:@current_user, user)

        post :create, params: {item: FactoryGirl.attributes_for(:book)}
      end

      it 'should respond with status unauthorized' do
        is_expected.to respond_with :unauthorized
      end
    end

    context 'when the user is admin' do
      before do
        @book_count = Book.count

        post :create, params: {item: FactoryGirl.attributes_for(:book, category_ids: [category.id], publish_detail_attributes: FactoryGirl.attributes_for(:publish_detail))}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should create new Book' do
        expect(Book.count).to eq @book_count + 1
      end
    end
  end

  describe '#show' do
    context 'when showing existing record' do
      before do
        get :show, id: book
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should assign book to @item' do
        expect(assigns(:item)).to eq book
      end
    end

    context 'when showing non existing record' do
      before do
        get :show, id: Item.last.id + 1
      end

      it { is_expected.to respond_with :not_found }
      it { is_expected.to rescue_from ActiveRecord::RecordNotFound }
    end
  end

  describe '#change_status' do
    context 'when status params is valid' do
      before do
        put :change_status, params: {id: book.id, status: Item.statuses.keys[Item.statuses[:INACTIVE]]}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should set book status as INACTIVE' do
        book.reload
        expect(book.INACTIVE?).to be_truthy
      end
    end

    context 'when status params is invalid' do
      before do
        put :change_status, params: {id: book.id, status: Faker::Lorem.word}
      end

      it 'should respond with status unprocessable_entity' do
        is_expected.to respond_with :unprocessable_entity
      end

      it 'should not change book status or say should be ACTIVE as default status is ACTIVE' do
        book.reload
        expect(book.INACTIVE?).to be_falsey
      end
    end
  end

  describe '#leased' do
    before do
      @book1, @book2, @book3 = FactoryGirl.create_list(:book, 3)
      @device1 = FactoryGirl.create(:device)
      @device2 = FactoryGirl.create(:device)

      FactoryGirl.create_list(:lease, @book1.quantity, item: @book1)
      FactoryGirl.create(:lease, item: @book2)
      FactoryGirl.create(:lease, item: @device1)
    end

    context 'when params type is undefined' do
      before do
        get :leased
      end

      it { is_expected.to respond_with :ok }
      it 'should list leased items' do
        expect(assigns(:items)).to match_array [@book1, @book2, @device1]
      end
    end

    context 'when params type is book' do
      before do
        get :leased, type: Book.to_s
      end

      it { is_expected.to respond_with :ok }
      it 'should list leased books' do
        expect(assigns(:items)).to match_array [@book1, @book2]
      end
    end

    context 'when params type is device' do
      before do
        get :leased, type: Device.to_s
      end

      it { is_expected.to respond_with :ok }
      it 'should list leased devices' do
        expect(assigns(:items)).to match_array [@device1]
      end
    end
  end

  describe '#most_rated' do
    let!(:kindle1) { FactoryGirl.create(:kindle) }
    let!(:kindle2) { FactoryGirl.create(:kindle) }

    before do
      Rating.delete_all
      FactoryGirl.create(:rating, value: 3, item: kindle1)
      FactoryGirl.create(:rating, value: 4, item: kindle2)
    end

    context 'when valid parameters are send' do
      before do
        get :most_rated, params: {type: Kindle.to_s, per_page: 1}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should provide most rated book' do
        expect(assigns(:items)).to match_array [kindle2]
      end
    end

    context 'when invalid parameter is send' do
      before do
        get :most_rated, params: {type: Faker::Lorem.word}
      end

      it 'should respond with status unprocessable_entity' do
        is_expected.to respond_with :unprocessable_entity
      end
    end
  end

  describe '#most_leased' do
    let(:book1) { FactoryGirl.create(:book, quantity: 3) }
    let(:book2) { FactoryGirl.create(:book) }

    before do
      Lease.delete_all
      FactoryGirl.create_list(:lease, 2, item: book1)
      FactoryGirl.create(:lease, item: book2)
    end

    context 'when valid parameters are send' do
      before do
        get :most_leased, params: {type: Book.to_s, per_page: 1}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should provide most leased book' do
        expect(assigns(:items)).to match_array [book1]
      end
    end

    context 'when invalid parameter is send' do
      before do
        get :most_leased, params: {type: Faker::Lorem.word}
      end

      it 'should respond with status unprocessable_entity' do
        is_expected.to respond_with :unprocessable_entity
      end
    end
  end
end
