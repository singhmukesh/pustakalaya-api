require 'rails_helper'

RSpec.describe Item, type: :model do
  subject { FactoryGirl.create(:book) }
  describe 'association' do
    it { is_expected.to have_and_belong_to_many :categories }
    it { is_expected.to have_many :leases }
    it { is_expected.to have_many :watches }
    it { is_expected.to have_many :ratings }
    it { is_expected.to have_many :reviews }
  end

  describe 'presence' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_presence_of :image }
  end

  describe 'uniqueness' do
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
  end

  describe '#rating' do
    let(:kindle) { FactoryGirl.create(:kindle) }

    context 'when kindle has rated' do
      it 'should provide average rating' do
        value1, value2, value3 = 3, 2, 5
        FactoryGirl.create(:rating, value: value1, item: kindle)
        FactoryGirl.create(:rating, value: value2, item: kindle)
        FactoryGirl.create(:rating, value: value3, item: kindle)

        expect(kindle.rating).to eq (value1+value2+value3)/3
      end
    end

    context 'when kindle has no any rating' do
      it 'should return 0' do
        expect(kindle.rating).to eq 0
      end
    end
  end
end
