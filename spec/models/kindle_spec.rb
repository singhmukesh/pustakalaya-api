require 'rails_helper'

RSpec.describe Kindle, type: :model do
  subject {FactoryGirl.build(:kindle)}

  describe 'uniqueness' do
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
  end
end
