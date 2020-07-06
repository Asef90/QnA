require 'rails_helper'

shared_examples_for 'subscripted' do

  let(:user) { create(:user) }
  let(:subscriptable) { create(described_class.controller_name.classify.underscore.to_sym) }

  describe 'PATCH #subscribe' do
    context 'authorized' do
      before { login(user) }

      context 'with valid attributes' do
        it 'adds a new subscription to current_user' do
          expect { patch :subscribe, params: { id: subscriptable.id }, format: :json }
          .to change(user.subscriptions, :count).by(1)
        end

        it 'responses 200 with success message' do
          expected = { message: "Successfully subscribed" }.to_json

          patch :subscribe, params: { id: subscriptable.id }, format: :json

          expect(response.status).to eq 200
          expect(response.body).to eq expected
        end
      end

      context 'with invalid attributes' do
        let!(:subscription) { create(:subscription, :on_question, subscriptable: subscriptable, user: user) }

        it 'does not add a new subscription to current_user' do
          expect { patch :subscribe, params: { id: subscriptable.id }, format: :json }
          .not_to change(user.subscriptions, :count)
        end

        it 'renders 422 with error messages' do
          expected = { errors: ['Subscriptable type has already been taken'] }.to_json

          patch :subscribe, params: { id: subscriptable.id }, format: :json
          expect(response.body).to eq expected
          expect(response.status).to eq 422
        end
      end
    end

    context 'Unauthenticated user tries to subscribe' do
      it 'does not change subscriptions number' do
        expect { patch :subscribe, params: { id: subscriptable.id }, format: :json }
        .not_to change(Subscription, :count)
      end

      it 'responses with code 403' do
        patch :subscribe, params: { id: subscriptable.id }, format: :json
        expect(response.status).to eq 403
      end
    end
  end

  describe 'PATCH #unsubscribe' do
    let!(:subscription) { create(:subscription, :on_question, subscriptable: subscriptable, user: user) }

    context 'authorized' do
      before { login(user) }

      context 'with valid attributes' do
        it "deletes current_user's subscription" do
          expect { patch :unsubscribe, params: { id: subscriptable.id }, format: :json }
          .to change(user.subscriptions, :count).by(-1)
        end

        it 'responses 200 with success message' do
          expected = { message: "Successfully unsubscribed" }.to_json

          patch :unsubscribe, params: { id: subscriptable.id }, format: :json

          expect(response.status).to eq 200
          expect(response.body).to eq expected
        end
      end
    end

    context 'Unauthenticated user tries to subscribe' do
      it 'does not change subscriptions number' do
        expect { patch :subscribe, params: { id: subscriptable.id }, format: :json }
        .not_to change(Subscription, :count)
      end

      it 'responses with code 403' do
        patch :unsubscribe, params: { id: subscriptable.id }, format: :json
        expect(response.status).to eq 403
      end
    end
  end
end
