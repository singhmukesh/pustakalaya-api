require 'rails_helper'

RSpec.describe V1::ItemsController, type: :controller do
end

require 'rails_helper'

RSpec.describe V1::ItemsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :role_admin) }
  let(:category) { FactoryGirl.create(:category, :group_book) }
  let(:book) { FactoryGirl.create(:book) }

  before do
    allow(controller).to receive(:authenticate_user!)
    controller.instance_variable_set(:@current_user, admin)
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
end
