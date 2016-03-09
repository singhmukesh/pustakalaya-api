require 'rails_helper'

RSpec.describe ItemPolicy do
  subject { ItemPolicy }
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :role_admin) }
  let(:item) { FactoryGirl.build(:book) }

  permissions :create?, :change_status?, :leased? do
    it 'should not allow user' do
      expect(subject).not_to permit(user, item)
    end

    it 'should allow admin' do
      expect(subject).to permit(admin, item)
    end
  end
end
