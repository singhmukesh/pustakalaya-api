require 'rails_helper'

RSpec.describe V1::CategoriesController, group: :controller do
  let(:user) { FactoryGirl.create(:user) }

  before do
    allow(controller).to receive(:authenticate_user!)
    controller.instance_variable_set(:@current_user, user)
  end

  describe '#index' do
    let(:book_category1) { FactoryGirl.create(:category, :group_book) }
    let(:book_category2) { FactoryGirl.create(:category, :group_book) }
    let(:device_category2) { FactoryGirl.create(:category, :group_device) }

    context "when params 'group' is undefined" do
      before do
        get :index
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should assign all active lease to @leases' do
        expect(assigns(:categories)).to match_array [book_category1, book_category2, device_category1]
      end
    end

    context "when params 'group' value is 'book'" do
      before do
        get :index, params: {group: Book.to_s}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should assign all active book lease to @leases' do
        expect(assigns(:categories)).to match_array [book_category1, book_category2]
      end
    end

    context "when params 'group' value is 'Device'" do
      before do
        get :index, params: {group: Device.to_s}
      end

      it 'should respond with status ok' do
        is_expected.to respond_with :ok
      end

      it 'should assign all active device lease to @leases' do
        expect(assigns(:categories)).to match_array [device_category1]
      end
    end
  end
end
