require 'rails_helper'

RSpec.describe Item, type: :model do
  subject {FactoryGirl.build(:book)}

  describe 'presence' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_presence_of :image }
  end

  describe 'uniqueness' do
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
  end
end
