require 'rails_helper'

RSpec.describe Watch, type: :model do
  describe 'association' do
    it { is_expected.to belong_to :item }
    it { is_expected.to belong_to :user }
  end

  describe 'validation' do
    context 'when available item is watched' do
      it 'should be invalid' do
        item = FactoryGirl.create(:book)
        lease = FactoryGirl.build(:watch, item_id: item.id)
        lease.valid?
        expect(lease.errors[:item_id][0]).to eq I18n.t('validation.available_to_lease')
      end
    end

    context 'when self leased is watched' do
      it 'should be invalid' do
        item = FactoryGirl.create(:book)
        user = FactoryGirl.create(:user)
        FactoryGirl.create(:lease, item_id: item.id, user_id: user.id)
        lease = FactoryGirl.build(:watch, item_id: item.id, user_id: user.id)
        lease.valid?
        expect(lease.errors[:item_id][0]).to eq I18n.t('validation.already_leased')
      end
    end

    context 'when watchlist item is watched' do
      it 'should be invalid' do
        item_quantity = 1
        item = FactoryGirl.create(:book, quantity: item_quantity)
        user = FactoryGirl.create(:user)
        FactoryGirl.create_list(:lease, item_quantity, item_id: item.id)
        FactoryGirl.create(:watch, item_id: item.id, user_id: user.id)

        lease = FactoryGirl.build(:watch, item_id: item.id, user_id: user.id)
        lease.valid?
        expect(lease.errors[:item_id][0]).to eq I18n.t('validation.already_watched')
      end
    end

    context 'when unavailable item is watched' do
      it 'should be valid' do
        item_quantity = 1
        item = FactoryGirl.create(:book, quantity: item_quantity)
        FactoryGirl.create_list(:lease, item_quantity, item_id: item.id)

        lease = FactoryGirl.build(:watch, item_id: item.id)
        expect(lease.valid?).to be_truthy
      end
    end
  end

  describe '#notify' do
    before do
      book_quantity = 1
      book = FactoryGirl.create(:book, quantity: book_quantity)
      FactoryGirl.create_list(:lease, book_quantity, item_id: book.id)
      @watch = FactoryGirl.create(:watch, item_id: book.id)
    end

    context 'when watch is active' do
      it 'should sends a watch successfull email' do
        expect { @watch.notify }.to change { Sidekiq::Extensions::DelayedMailer.jobs.size }.by(1)
      end
    end

    context 'when watch is inactive' do
      before do
        @watch.INACTIVE!
      end

      it 'should sends a unwatch successfull email' do
        expect { @watch.notify }.to change { Sidekiq::Extensions::DelayedMailer.jobs.size }.by(1)
      end
    end
  end
end
