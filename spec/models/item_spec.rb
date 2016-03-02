require 'rails_helper'

RSpec.describe Item, type: :model do
  subject { FactoryGirl.create(:book) }
  describe 'association' do
    it { is_expected.to have_and_belong_to_many :categories }
    it { is_expected.to have_many :leases }
    it { is_expected.to have_many :watches }
    it { is_expected.to have_many :ratings }
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
end
