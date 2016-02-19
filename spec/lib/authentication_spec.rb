require 'rails_helper'

RSpec.describe Authentication, type: :lib do
  include Authentication

  user_detail = JSON.parse(File.read('spec/support/json/user.json'))

  describe '#authenticate_with_oauth' do
    context 'when the auth token is invalid' do
      it 'should raise exception CustomException::Unauthorized' do
        expect { Authentication::authenticate_with_oauth(Faker::Lorem.characters) }.to raise_exception CustomException::Unauthorized
      end
    end
  end

  describe '#authenticate_domain' do
    context 'when the auth domain does not match' do
      it 'should raise exception CustomException::DomainConflict' do
        ENV['AUTH_DOMAIN'] = 'foo.com'
        expect { Authentication::authenticate_domain(user_detail) }.to raise_exception CustomException::DomainConflict
      end
    end

    context 'when the auth domain matches' do
      it 'should return true' do
        ENV['AUTH_DOMAIN'] = 'example.com'
        expect(Authentication::authenticate_domain(user_detail)).to be_truthy
      end
    end
  end
end
