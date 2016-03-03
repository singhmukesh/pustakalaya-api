require 'rails_helper'

RSpec.describe Review, type: :model do
  let!(:book) { FactoryGirl.create(:book) }

  subject { FactoryGirl.create(:review, item: book) }

  describe 'association' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :item }
  end

  describe 'presence' do
    it { is_expected.to validate_presence_of :description }
  end

  describe 'validation' do
    context 'when unreviewable item is reviewed' do
      let(:device) { FactoryGirl.create(:device) }
      it 'should set error' do
        rating = FactoryGirl.build(:review, item: device)
        rating.valid?
        expect(rating.errors[:item_id][0]).to eq I18n.t('validation.item_not_reviewable')
      end
    end
  end
end
