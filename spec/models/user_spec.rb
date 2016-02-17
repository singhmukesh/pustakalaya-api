require 'rails_helper'

RSpec.describe User, type: :model do
  subject {FactoryGirl.build(:user, :role_user)}

  describe 'presence' do
    it { is_expected.to validate_presence_of :role }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :uid }
  end

  describe 'uniqueness' do
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end
end
