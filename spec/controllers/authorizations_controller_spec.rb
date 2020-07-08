require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }
  let!(:authorization) { create(:authorization) }

  describe 'GET #confirmation' do
    it 'renders confirmation view' do
      get :confirmation
      expect(response).to render_template :confirmation
    end
  end

  describe 'PATCH #handle' do
    before do
      session[:provider] = authorization.provider
      session[:uid] = authorization.uid
    end

    it 'finds authorization by provider and uid' do
      patch :handle, params: { email: user.email }

      expect(assigns(:authorization)).to eq authorization
    end

    it "generates authorization's token" do
      expect(authorization.token).to eq nil

      patch :handle, params: { email: user.email }
      authorization.reload

      expect(authorization.token).not_to eq nil
    end

    it 'sends confirmation email to user' do
      expect { patch :handle, params: { email: user.email } }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
    end
  end

  describe 'GET #confirm' do
    before do
      authorization.update(token: 123456)
    end

    context 'params token equal to authorization token' do
      it 'finds authorization by id' do
        get :confirm, params: { id: authorization, token: authorization.token, email: user.email }

        expect(assigns(:authorization)).to eq authorization
      end

      it "changes authorization's confirmed value to true" do
        get :confirm, params: { id: authorization, token: authorization.token, email: user.email }
        authorization.reload

        expect(authorization.confirmed).to be_truthy
      end

      it 'adds authorization to user' do
        expect { get :confirm, params: { id: authorization, token: authorization.token, email: user.email } }
                 .to change(user.authorizations, :count).by(1)
      end

      it 'adds current authorization to user' do
        get :confirm, params: { id: authorization, token: authorization.token, email: user.email }
        expect(user.authorizations.first).to eq authorization
      end
    end

    context 'params token not equal to authorization token' do
      it 'redirects to root path' do
        get :confirm, params: { id: authorization, token: 123123, email: user.email }
        expect(response).to redirect_to root_path
      end
    end
  end
end
