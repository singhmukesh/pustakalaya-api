require 'rails_helper'

RSpec.describe V1::BooksController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  before do
    allow(controller).to receive(:authenticate_user!)
    controller.instance_variable_set(:@current_user, user)
  end

  describe '#available' do
    before do
      @book1, @book2, @book3 = FactoryGirl.create_list(:book, 3)
      FactoryGirl.create_list(:lease, @book1.quantity, item: @book1)
      FactoryGirl.create_list(:lease, @book2.quantity - 1, item: @book2)

      get :available
    end

    it { is_expected.to respond_with :ok }
    it 'should list default number of available books' do
      expect(assigns(:books)).to match_array [@book2, @book3]
    end
  end

  describe '#leased' do
    before do
      @book1, @book2, @book3 = FactoryGirl.create_list(:book, 3)
      FactoryGirl.create_list(:lease, @book1.quantity, item: @book1)
      FactoryGirl.create(:lease, item: @book2)

      get :leased
    end

    it { is_expected.to respond_with :ok }
    it 'should list default number of available books' do
      expect(assigns(:books)).to match_array [@book1, @book2]
    end
  end

end
