require 'rails_helper'
require 'webmock/rspec'


RSpec.describe PublishDetail, type: :model do
  describe 'presence' do
    it { is_expected.to validate_presence_of :author }
  end

  describe 'association' do
    it { is_expected.to belong_to :item }
  end

  describe '#goodreads' do
    before do
      @publish_detail = FactoryGirl.create(:book).publish_detail
    end

    context 'when isbn in empty' do
      before do
        @publish_detail.update(isbn: '')
      end
      it 'should return nil' do
        expect(@publish_detail.goodreads).to eql(nil)
      end
    end

    context 'when isbn is invalid' do
      before do
        @publish_detail.update(isbn: 'invalid')
      end
      it 'should return nil' do
        stub_request(:get, /www.goodreads.com/)
        .to_return(status: 404, body: '<error>book not found</error>', headers: {'Content-Type' => 'application/xml; charset=utf-8'})
        expect(@publish_detail.goodreads).to eql(nil)
      end
    end

  end


end
