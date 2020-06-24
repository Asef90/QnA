require 'rails_helper'

RSpec.describe FindForOauthService do

  let!(:user) { create(:user) }
  subject { FindForOauthService.new(auth) }

  context 'parameter contains email' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456', confirmed: true)

        expect(subject.call).to eq user
      end
    end

    context 'user has not authorization' do
      before do
        allow(auth.info).to receive(:[]).with(:email).and_return(user.email)
      end

      it 'calls find_or_create user' do
        expect(User).to receive(:find_or_create).with(user.email).and_return(user)

        subject.call
      end

      it 'creates authorization for user' do
        expect { subject.call }.to change(user.authorizations, :count).by(1)
      end

      it 'creates confirmed authorization with provider and uid' do
        authorization = subject.call.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
        expect(authorization.confirmed).to be_truthy
      end

      it 'returns the user' do
        expect(subject.call).to eq user
      end
    end
  end

  context 'without email' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    before do
      allow(auth.info).to receive(:[]).with(:email)
    end

    it 'creates new authorization' do
      expect { subject.call }.to change(Authorization, :count).by(1)
    end

    it 'creates unconfirmed authorization with provider and uid' do
      subject.call
      authorization = Authorization.first

      expect(authorization.provider).to eq auth.provider
      expect(authorization.uid).to eq auth.uid
      expect(authorization.confirmed).to be_falsey
    end

    it 'returns nil' do
      expect(subject.call).not_to be
    end
  end
end
