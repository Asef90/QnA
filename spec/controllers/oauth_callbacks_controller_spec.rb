require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    let!(:oauth_data) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }

    before do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
    end

    it 'finds user from oauth data' do
      expect(User).to receive(:from_omniauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:from_omniauth).and_return(user)
        get :github
      end

      it 'logins user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:from_omniauth)
        get :github
      end

      it 'does not login user' do
        expect(subject.current_user).not_to be
      end

      it 'adds to session provider and uid values' do
        expect(session[:provider]).to eq oauth_data.provider
        expect(session[:uid]).to eq oauth_data.uid
      end

      it 'redirects to enter email for confirmation path' do
        expect(response).to redirect_to authorizations_confirmation_path
      end
    end
  end
end
