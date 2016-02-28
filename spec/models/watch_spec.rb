require 'rails_helper'

RSpec.describe Watch, type: :model do
  describe 'association' do
    it { is_expected.to belong_to :item }
    it { is_expected.to belong_to :user }
  end
end
