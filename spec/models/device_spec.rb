require 'rails_helper'

RSpec.describe Device, type: :model do
  subject {FactoryGirl.build(:device)}

  describe 'uniqueness' do
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
  end

  describe 'association' do
    it { is_expected.to have_many(:leases).with_foreign_key(:item_id) }
  end
end
