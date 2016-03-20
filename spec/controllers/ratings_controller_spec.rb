require 'rails_helper'

RSpec.describe V1::RatingsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:book) { FactoryGirl.create(:book) }
  let(:device) { FactoryGirl.create(:device) }

  before do
    allow(controller).to receive(:authenticate_user!)
    controller.instance_variable_set(:@current_user, user)
  end

  describe '#create' do
    context 'when rateable item is rated' do
      before do
        @rating_count = Rating.count
        post :create, params: {rating: FactoryGirl.attributes_for(:rating, item_id: book.id)}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should create new Rating' do
        expect(Rating.count).to eq @rating_count + 1
      end

      it 'should have last rated item as book' do
        expect(Rating.last.item.code).to eq book.code
      end
    end

    context 'when non rateable item is rated' do
      before do
        @rating_count = Rating.count
        post :create, params: {rating: FactoryGirl.attributes_for(:rating, item_id: device.id)}
      end

      it 'should respond with status unprocessable_entity' do
        is_expected.to respond_with :unprocessable_entity
      end

      it 'should not create new Rating' do
        expect(Rating.count).to eq @rating_count
      end
    end

    context 'when already rateable item is rated' do
      before do
        FactoryGirl.create(:rating, user: user, item: book)
        @rating_count = Rating.count
        @value = Faker::Number.between(1, Rating::UPPER_BOUND)
        post :create, params: {rating: FactoryGirl.attributes_for(:rating, value: @value, item_id: book.id)}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should not create new Rating' do
        expect(Rating.count).to eq @rating_count
      end

      it 'should change rating value' do
        expect(user.ratings.find_by(item_id: book.id).value).to eq @value
      end
    end
  end
end
