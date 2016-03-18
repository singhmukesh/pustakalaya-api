require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Authentication, type: :lib do
  include Authentication

  user_detail = JSON.parse(File.read('spec/support/json/user.json'))

  describe '.login' do
    context 'when the request has valid authorization token' do
      before do
        @access_token = Faker::Lorem.characters
        @result = '{
      "access_token": "'+@access_token+'",
      "token_type": "Bearer",
      "expires_in": 3331,
      "id_token": "'+Faker::Lorem.characters+'"
      }'
      end

      it 'should respond with access_token and refresh_token' do
        stub_request(:post, /www.googleapis.com/)
        .to_return(status: 200, body: @result, headers: {'Content-Type' => 'application/json'})

        expect(Authentication::login(Faker::Lorem.characters)).to eq({access_token: @access_token, refresh_token: nil})
      end
    end

    context 'when the request has valid authorization token' do
      it 'should raise CustomException::Unauthorized' do
        stub_request(:post, /www.googleapis.com/)
        .to_return(status: 400, body: '{"error": "Unauthorized request"}', headers: {'Content-Type' => 'application/json'})

        expect { Authentication::login(Faker::Lorem.characters) }.to raise_exception CustomException::Unauthorized
      end
    end

    context 'when the request to server get timeout' do
      it 'should raise CustomException::RequestTimeOut' do
        stub_request(:post, /www.googleapis.com/).to_timeout

        expect { Authentication::login(Faker::Lorem.characters) }.to raise_exception CustomException::RequestTimeOut
      end
    end
  end

  describe '.get_user_info_from_access_token' do
    context 'when the request has valid authorization token' do
      before do
        @given_name = Faker::Name.first_name
        @result = '{"id": "12312a1212",
            "email": "pustkaly_user@example.com",
            "verified_email": true,
            "given_name": "'+@given_name+'",
            "family_name": "Lamsal",
            "gender": "male",
            "locale": "en",
            "hd": "example.com"}'
      end

      it 'should provides information of the users' do
        stub_request(:get, /www.googleapis.com/)
        .to_return(status: 200, body: @result, headers: {'Content-Type' => 'application/json'})

        expect(Authentication::get_user_info_from_access_token(Faker::Lorem.characters)['given_name']).to eq(@given_name)
      end
    end

    context 'when the access token is invalid' do
      it 'should raise exception CustomException::Unauthorized' do
        stub_request(:get, /www.googleapis.com/)
        .to_return(status: 400, body: '{"error": "Unauthorized request"}', headers: {'Content-Type' => 'application/json'})

        expect { Authentication::get_user_info_from_access_token(Faker::Lorem.characters) }.to raise_exception CustomException::Unauthorized
      end
    end

    context 'when the request to server get timeout' do
      it 'should raise CustomException::RequestTimeOut' do
        stub_request(:get, /www.googleapis.com/).to_timeout

        expect { Authentication::get_user_info_from_access_token(Faker::Lorem.characters) }.to raise_exception CustomException::RequestTimeOut
      end
    end
  end

  describe '.authenticate_domain' do
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
