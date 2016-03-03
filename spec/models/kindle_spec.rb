require 'rails_helper'

RSpec.describe Kindle, type: :model do
  subject { FactoryGirl.build(:kindle) }

  describe 'presence' do
    it { is_expected.to validate_presence_of :publish_detail }
  end

  describe 'uniqueness' do
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
  end

  describe 'association' do
    it { is_expected.to have_one(:publish_detail).with_foreign_key(:item_id) }
  end

  describe '#rating' do
    let(:kindle) { FactoryGirl.create(:kindle) }
    it 'should provide average rating' do
      value1, value2, value3 = 3, 2, 5
      FactoryGirl.create(:rating, value: value1, item: kindle)
      FactoryGirl.create(:rating, value: value2, item: kindle)
      FactoryGirl.create(:rating, value: value3, item: kindle)

      expect(kindle.rating).to eq (value1+value2+value3)/3
    end
  end
end
