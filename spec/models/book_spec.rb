require 'rails_helper'

RSpec.describe Book, type: :model do
  subject { FactoryGirl.build(:book) }

  describe 'presence' do
    it { is_expected.to validate_presence_of :publish_detail }
  end

  describe 'uniqueness' do
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
  end

  describe 'association' do
    it { is_expected.to have_one(:publish_detail).with_foreign_key(:item_id) }
    it { is_expected.to have_many(:leases).with_foreign_key(:item_id) }
  end

  describe '#available?' do
    before do
      @book_quantity = 2
      @book = FactoryGirl.create(:book, quantity: @book_quantity)
    end

    context 'when no any previous lease are made' do
      it 'should return true' do
        expect(@book.available?).to be_truthy
      end
    end

    context 'when previous lease are made but less than quantity' do
      it 'should return true' do
        FactoryGirl.create_list(:lease, @book_quantity - 1, item_id: @book.id)
        expect(@book.available?).to be_truthy
      end
    end

    context 'when previous lease are made upto book quantity' do
      it 'should return false' do
        FactoryGirl.create_list(:lease, @book_quantity, item_id: @book.id)
        expect(@book.available?).to be_falsey
      end
    end
  end
end
