require 'rails_helper'

RSpec.describe V1::AuthorsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  before do
    allow(controller).to receive(:authenticate_user!)
    controller.instance_variable_set(:@current_user, user)
  end

  describe '#index' do
    let!(:author1) { Faker::Name.name }
    let!(:author2) { Faker::Name.name }
    let!(:publish_detail1) { FactoryGirl.create(:publish_detail, author: author1) }
    let!(:publish_detail2) { FactoryGirl.create(:publish_detail, author: author2) }

    before do
      FactoryGirl.create(:book, publish_detail: publish_detail1)
      FactoryGirl.create(:kindle, publish_detail: publish_detail2)

      get :index
    end

    it { is_expected.to respond_with :ok }
    it 'should assign all the authors to @authors' do
      expect(assigns(:authors)).to match_array [author1, author2]
    end
  end
end
