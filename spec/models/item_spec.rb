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

  describe '.rateable?' do
    context 'when item is Book' do
      it { expect(Item.rateable?(Book.to_s)).to be_truthy }
    end

    context 'when item is Device' do
      it { expect(Item.rateable?(Device.to_s)).to be_falsey }
    end

    context 'when item is Kindle' do
      it { expect(Item.rateable?(Kindle.to_s)).to be_truthy }
    end
  end

  describe '.leaseable?' do
    context 'when item is Book' do
      it { expect(Item.leaseable?(Book.to_s)).to be_truthy }
    end

    context 'when item is Device' do
      it { expect(Item.leaseable?(Device.to_s)).to be_truthy }
    end

    context 'when item is Kindle' do
      it { expect(Item.leaseable?(Kindle.to_s)).to be_falsey }
    end
  end

  describe '.most_rated' do
    let(:book1) { FactoryGirl.create(:book) }
    let(:book2) { FactoryGirl.create(:book) }

    before do
      FactoryGirl.create(:rating, value: 4, item: book1)
      FactoryGirl.create(:rating, value: 3, item: book2)
    end

    it 'should provide Book with highest rating' do
      expect(Item.most_rated).to eq [book1, book2]
    end
  end

  describe '.most_leased' do
    context 'when params type is Book' do
      let(:book1) { FactoryGirl.create(:book) }
      let(:book2) { FactoryGirl.create(:book) }

      before do
        FactoryGirl.create_list(:lease, 3, item: book1)
        FactoryGirl.create(:lease, item: book2)
        FactoryGirl.create(:lease)
      end

      it 'should provide most leased Book' do
        expect(Item.most_leased(Book.to_s)).to eq [book1, book2]
      end
    end

    context 'when params type is Device' do
      let(:device1) { FactoryGirl.create(:device) }
      let(:device2) { FactoryGirl.create(:device) }

      before do
        FactoryGirl.create_list(:lease, 2, item: device1)
        FactoryGirl.create(:lease, item: device2)
      end

      it 'should provide most leased Book' do
        expect(Item.most_leased(Device.to_s)).to eq [device1, device2]
      end
    end
  end
end
