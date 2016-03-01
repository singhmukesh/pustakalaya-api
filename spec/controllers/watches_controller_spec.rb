require 'rails_helper'

RSpec.describe V1::WatchesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:book) { FactoryGirl.create(:book) }

  before do
    allow(controller).to receive(:authenticate_user!)
    controller.instance_variable_set(:@current_user, user)
  end

  describe '#create' do
    before do
      @watch_count = Watch.count
      book.update_attribute(:quantity, 1)
      FactoryGirl.create(:lease, item_id: book.id)
      post :create, params: {watch: FactoryGirl.attributes_for(:watch, item_id: book.id)}
    end

    it 'should respond with status ok' do
      is_expected.to respond_with :ok
    end

    it 'should create new Lease' do
      expect(Watch.count).to eq @watch_count + 1
    end

    it 'should have lease item as book' do
      expect(Watch.last.item.code).to eq book.code
    end
  end

  describe '#unwatch' do
    before do
      book.update_attribute(:quantity, 1)
      FactoryGirl.create(:lease, item_id: book.id)
    end

    context 'with valid attributes' do
      before do
        @watch = FactoryGirl.create(:watch, item_id: book.id, user_id: user.id)
        post :unwatch, params: { item_id: book.id }
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should have status as INACTIVE' do
        @watch.reload
        expect(@watch.INACTIVE?).to be_truthy
      end
    end

    context 'with invalid attributes' do
      before do
        @watch = FactoryGirl.create(:watch, item_id: book.id, user_id: FactoryGirl.create(:user).id)
        post :unwatch, params: { item_id: book.id }
      end

      it 'should respond with status unauthorized' do
        is_expected.to respond_with :unauthorized
      end
    end
  end
end
