require 'rails_helper'

RSpec.describe Rating, type: :model do
  subject { FactoryGirl.create(:rating) }

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
end
