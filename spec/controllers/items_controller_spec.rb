require 'rails_helper'

RSpec.describe V1::ItemsController, type: :controller do
end

require 'rails_helper'

RSpec.describe V1::ItemsController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :role_admin) }
  let(:category) { FactoryGirl.create(:category, :group_book) }

  before { allow(controller).to receive(:authenticate_user!) }

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
        controller.instance_variable_set(:@current_user, admin)
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
end
