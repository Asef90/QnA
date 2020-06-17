require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do
  let(:user) { create(:user) }
  let!(:authorization) { create(:authorization) }

  before do
    allow(Authorization).to receive(:find_by)
                        .with(provider: session[:provider], uid: session[:uid])
                        .and_return(authorization)
  end

  describe 'GET #confirmation' do
    it 'renders confirmation view' do
      get :confirmation
      expect(response).to render_template :confirmation
    end
  end

  describe 'PATCH #handle' do

    it "generates authorization's token" do
      expect(authorization.token).to eq nil

      patch :handle, params: { email: user.email }
      expect(authorization.token).not_to eq nil
    end

    it 'adds to session email value' do
      patch :handle, params: { email: user.email }
      expect(session[:user_email]).to eq user.email
    end

    it 'sends confirmation email to user' do
      expect { patch :handle, params: { email: user.email } }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

  end

  describe 'GET #confirm' do
    before do
      authorization.update(token: 123456)
    end

    context 'params token equal to authorization token' do
      before do
        allow(User).to receive(:find_or_create).with(session[:user_email]).and_return(user)
      end

      it "changes authorization's confirmed value to true" do
        get :confirm, params: { token: authorization.token }
        expect(authorization.confirmed).to be_truthy
      end

      it 'adds authorization to user' do
        expect { get :confirm, params: { token: authorization.token } }.to change(user.authorizations, :count).by(1)
      end

      it 'adds current authorization to user' do
        get :confirm, params: { token: authorization.token }
        expect(user.authorizations.first).to eq authorization
      end
    end

    context 'params token not equal to authorization token' do
      it 'redirects to root path' do
        get :confirm, params: { token: 123123 }
        expect(response).to redirect_to root_path
      end
    end
  end
end
