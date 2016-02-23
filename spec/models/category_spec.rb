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
end
