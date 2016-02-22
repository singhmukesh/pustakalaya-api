require 'rails_helper'

RSpec.describe Device, type: :model do
  subject {FactoryGirl.build(:device)}

  describe 'uniqueness' do
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
  end
end
