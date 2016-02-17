require 'rails_helper'

RSpec.describe Authentication, type: :lib do
  include Authentication

  describe '#authenticate_with_oauth' do
    context 'when the auth token is invalid' do
      it 'should raise exception CustomException::Unauthorized' do
        expect { Authentication::authenticate_with_oauth(Faker::Lorem.characters) }.to raise_exception CustomException::Unauthorized
      end
    end
  end
end
