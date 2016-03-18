require 'rails_helper'

RSpec.describe V1::SessionController, type: :controller do

  describe '#login' do

    context 'when the authorization_token is valid' do
      let(:refresh_token) {Faker::Lorem.characters}
      let(:access_token) {Faker::Lorem.characters}
      before do
        @response = {
          refresh_token: refresh_token,
          access_token: access_token
        }
        allow(Authentication).to receive(:login).and_return(@response)

        post :login
      end

      it 'should respond with ok' do
        is_expected.to respond_with :ok
      end

      it 'should set instance variable @login which has access_token' do
        expect(assigns(:login)[:access_token]).to eq access_token
      end

      it 'should set instance variable @login which has refresh_token' do
        expect(assigns(:login)[:refresh_token]).to eq refresh_token
      end
    end

    context 'when the authorization_token is invalid' do
      before do
        WebMock.stub_request(:post, /www.googleapis.com/)
        .to_return(status: 400, body: '{"error": "Unauthorized request"}', headers: {'Content-Type' => 'application/json'})

        post :login
      end

      it 'should respond with :unauthorized' do
        is_expected.to respond_with :unauthorized
      end
    end
  end
end
