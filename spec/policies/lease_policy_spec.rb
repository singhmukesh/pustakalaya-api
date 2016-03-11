require 'rails_helper'

RSpec.describe LeasePolicy do
  subject { LeasePolicy }
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :role_admin) }
  let(:lease) { FactoryGirl.build(:lease) }

  permissions :index? do
    it 'should not allow user' do
      expect(subject).not_to permit(user, lease)
    end

    it 'should allow admin' do
      expect(subject).to permit(admin, lease)
    end
  end
end
