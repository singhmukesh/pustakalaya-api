require 'rails_helper'

RSpec.describe V1::BooksController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  before do
    FactoryGirl.create_list(:book, 12)
    allow(controller).to receive(:authenticate_user!)
  end

  describe '#index' do
    context 'without params' do
      before do
        controller.instance_variable_set(:@current_user, user)
        get :index
      end

      it { is_expected.to respond_with :ok }
      it 'should list default number of books' do
        expect(assigns(:books)).to match_array Book.ACTIVE.order('created_at DESC').limit(WillPaginate.per_page)
      end
    end

    context 'with pagination' do
      context 'with per page value in first page' do
        let(:page) { 1 }
        let(:per_page) { 3 }

        before do
          get :index, page: page, per_page: per_page
        end

        it { is_expected.to respond_with :ok }
        it 'assigns the last three books to @books' do
          expect(assigns(:books)).to match_array Book.ACTIVE.order('created_at DESC').limit(3)
        end
      end
    end
  end

  describe '#inactivated' do
    before do
      get :inactivated
    end

    it { is_expected.to respond_with :ok }
    it 'should inactive books list' do
      Book.last.INACTIVE!
      inactive_book1 = Book.last
      inactive_book2 = FactoryGirl.create(:book, status: Item.statuses[:INACTIVE])

      expect(assigns(:books)).to match_array [inactive_book1, inactive_book2]
    end
  end
end
