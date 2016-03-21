require 'rails_helper'

RSpec.describe V1::RatingsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:book) { FactoryGirl.create(:book) }
  let(:device) { FactoryGirl.create(:device) }
  let(:user_detail) { JSON.parse(File.read('spec/support/json/user.json')) }
  
  describe '#create' do
    context 'when Authentication params are valid' do
      before do
        allow(controller).to receive(:authenticate_user!)
        controller.instance_variable_set(:@current_user, user)
      end

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

    context 'when the domain of user OAuth mail address does not match' do
      before do
        ENV['AUTH_DOMAIN'] = user_detail['hd'] + Faker::Lorem.word
        allow(Authentication).to receive(:get_user_info_from_access_token).and_return(user_detail)

        post :create, params: {rating: FactoryGirl.attributes_for(:rating, item_id: book.id)}
      end

      it 'should respond with :conflict' do
        is_expected.to respond_with :conflict
      end
    end

    context 'when the OAuth information can not be retrieve' do
      before do
        allow(Authentication).to receive(:get_user_info_from_access_token).and_raise(CustomException::RequestTimeOut)

        post :create, params: {rating: FactoryGirl.attributes_for(:rating, item_id: book.id)}
      end

      it 'should respond with :request_timeout' do
        is_expected.to respond_with :request_timeout
      end
    end

    context 'when user is yet not registered' do
      before do
        @user_detail = JSON.parse(File.read('spec/support/json/user.json'))
        allow(Authentication).to receive(:get_user_info_from_access_token).and_return(@user_detail)
        allow(Authentication).to receive(:authenticate_domain).and_return(true)

        post :create, params: {rating: FactoryGirl.attributes_for(:rating, item_id: book.id)}
      end

      it 'should create user with same uid' do
        expect(User.find_by(uid: @user_detail['id'])).to be_present
      end
    end
  end
end
