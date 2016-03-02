require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryGirl.build(:user) }

  user_detail = JSON.parse(File.read('spec/support/json/user.json'))

  describe 'association' do
    it { is_expected.to have_many :leases }
    it { is_expected.to have_many :watches }
    it { is_expected.to have_many :ratings }
  end

  describe 'presence' do
    it { is_expected.to validate_presence_of :role }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :uid }
  end

  describe 'uniqueness' do
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe '.find_user' do
    context 'when user is not previously present' do
      before do
        @user_count = User.count
      end

      it 'should not add new user' do
        User.find_user(user_detail)
        expect(User.count).to eq @user_count + 1
      end

      it 'should add new user with provided details' do
        User.find_user(user_detail)
        expect(User.last.uid).to eq user_detail['id']
      end
    end

    context 'when user is previously present' do
      before do
        User.find_user(user_detail)
        @user_count = User.count
      end

      it 'should not add new user' do
        User.find_user(user_detail)
        expect(User.count).to eq @user_count
      end
    end

    it 'should return User::ActiveRecord_Relation object' do
      expect(User.find_user(user_detail)).to eq User.find_by(uid: user_detail['id'])
    end
  end
end
