require 'rails_helper'

RSpec.describe Rating, type: :model do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:book) { FactoryGirl.create(:book) }

  subject { FactoryGirl.create(:rating, user: user, item: book) }

  describe 'association' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :item }
  end

  describe 'numericality' do
    it { is_expected.to validate_numericality_of(:value).is_less_than_or_equal_to(Rating::UPPER_BOUND).is_greater_than(0) }
  end

  describe 'unique' do
    it { is_expected.to validate_uniqueness_of(:item_id).scoped_to(:user_id) }
  end

  describe 'validation' do
    context 'when unrateable item' do
      let(:device) { FactoryGirl.create(:device) }
      it 'should set error' do
        rating = FactoryGirl.build(:rating, item: device)
        rating.valid?
        expect(rating.errors[:item_id][0]).to eq I18n.t('validation.item_not_rateable')
      end
    end
  end
end
