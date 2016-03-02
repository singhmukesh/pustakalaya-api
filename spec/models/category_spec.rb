require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { FactoryGirl.build(:category, :group_book) }

  describe 'presence' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:group) }
  end

  describe 'uniqueness' do
    it { is_expected.to validate_uniqueness_of(:title).case_insensitive }
  end

  describe '.list' do
    let(:book_category1) { FactoryGirl.create(:category, :group_book) }
    let(:book_category2) { FactoryGirl.create(:category, :group_book) }
    let(:device_category1) { FactoryGirl.create(:category, :group_device) }

    context "when params 'group' is undefined" do
      it 'should provide all categories' do
        expect(Category.list).to match_array [book_category1, book_category2, device_category1]
      end
    end

    context "when params 'group' value is 'book'" do
      it "should provides all Category with group value 'Book'" do
        expect(Category.list(Book.to_s)).to match_array [book_category1, book_category2]
      end
    end

    context "when params 'group' value is 'Device'" do
      it "should provides all Category with group value 'Device'" do
        expect(Category.list(Device.to_s)).to match_array [device_category1]
      end
    end
  end
end
