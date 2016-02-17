require 'rails_helper'

RSpec.describe Authentication, type: :lib do
  include Authentication

  describe '#authenticate_with_oauth' do
    context 'when the auth token is invalid' do
      it 'should have response with status code 401' do
        response = Authentication::authenticate_with_oauth(Faker::Lorem.characters)
        expect(response.code).to eq 401
      end
    end
  end
end
