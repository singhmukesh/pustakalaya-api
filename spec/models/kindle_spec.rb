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
end
