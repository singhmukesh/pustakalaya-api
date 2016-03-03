require 'rails_helper'

RSpec.describe V1::ReviewsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:book) { FactoryGirl.create(:book) }
  let(:device) { FactoryGirl.create(:device) }

  before do
    allow(controller).to receive(:authenticate_user!)
    controller.instance_variable_set(:@current_user, user)
  end

  describe '#create' do
    context 'when reviewable item is reviewed' do
      before do
        @review_count = Review.count
        post :create, params: {review: FactoryGirl.attributes_for(:review, item_id: book.id)}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should create new Review' do
        expect(Review.count).to eq @review_count + 1
      end

      it 'should have last reviewed item as book' do
        expect(Review.last.item.code).to eq book.code
      end
    end

    context 'when non reviewable item is reviewed' do
      before do
        @review_count = Review.count
        post :create, params: {review: FactoryGirl.attributes_for(:review, item_id: device.id)}
      end

      it 'should respond with status unprocessable_entity' do
        is_expected.to respond_with :unprocessable_entity
      end

      it 'should not create new Rating' do
        expect(Review.count).to eq @review_count
      end
    end

    context 'when already reviewable item is reviewed' do
      before do
        FactoryGirl.create(:review, user: user, item: book)
        @review_count = Review.count
        post :create, params: {review: FactoryGirl.attributes_for(:review, item_id: book.id)}
      end

      it 'should respond with status unprocessable_entity' do
        is_expected.to respond_with :unprocessable_entity
      end

      it 'should not create new Rating' do
        expect(Review.count).to eq @review_count
      end
    end
  end
end
