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

  describe '#leases?' do
    context 'when the provided item is leased by user' do
      it 'should return true' do
        user = FactoryGirl.create(:user)
        book = FactoryGirl.create(:book)
        FactoryGirl.create(:lease, user: user, item: book)

        expect(user.leased?(book.id)).to be_truthy
      end
    end

    context 'when the provided item is not leased by user' do
      it 'should return true' do
        user = FactoryGirl.create(:user)
        book = FactoryGirl.create(:book)

        expect(user.leased?(book.id)).to be_falsey
      end
    end
  end

  describe '#watched?' do
    context 'when the provided item is in watchlist of user' do
      it 'should return true' do
        user = FactoryGirl.create(:user)
        book_quantity = 1
        book = FactoryGirl.create(:book, quantity: book_quantity)
        FactoryGirl.create_list(:lease, book_quantity, item: book)
        FactoryGirl.create(:watch, user: user, item: book)

        expect(user.watched?(book.id)).to be_truthy
      end
    end

    context 'when the provided item is not in watchlist of user' do
      it 'should return true' do
        user = FactoryGirl.create(:user)
        book = FactoryGirl.create(:book)

        expect(user.watched?(book.id)).to be_falsey
      end
    end
  end

  describe '.with_most_leases' do
    before do
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @user3 = FactoryGirl.create(:user)

      FactoryGirl.create_list(:lease, 3, user: @user1)
      FactoryGirl.create_list(:lease, 2, user: @user2)
      FactoryGirl.create(:lease, user: @user3)

      FactoryGirl.create(:lease, :lease_book, user: @user1)
      FactoryGirl.create_list(:lease, 2, :lease_book, user: @user2)
    end

    context 'when item type is not defined' do
      it 'should provide top user of Book' do
        expect(User.with_most_leases(nil)).to eq [@user2, @user1]
      end
    end

    context 'when item type is Book' do
      it 'should provide top user of Book' do
        expect(User.with_most_leases(Book.to_s)).to eq [@user2, @user1]
      end
    end

    context 'when item type is Device' do
      it 'should provide top user of Device' do
        expect(User.with_most_leases(Device.to_s)).to eq [@user1, @user2, @user3]
      end
    end
  end
end
