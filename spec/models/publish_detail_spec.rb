require 'rails_helper'

RSpec.describe PublishDetail, :type => :model do
  describe 'presence' do
    it { is_expected.to validate_presence_of :isbn }
    it { is_expected.to validate_presence_of :author }
    it { is_expected.to validate_presence_of :publish_date }
  end

  describe 'association' do
    it { is_expected.to belong_to :item }
  end
end
