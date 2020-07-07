require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'authorized' do
      before { login(user) }

      context 'with valid attributes' do
        it 'adds a new subscription to current_user' do
          expect { post :create, params: { question_id: question.id, subscriptable: 'questions' }, format: :json }
          .to change(user.subscriptions, :count).by(1)
        end

        it 'responses 200 with success message' do
          expected = { message: "Successfully subscribed" }.to_json

          post :create, params: { question_id: question.id, subscriptable: 'questions' }, format: :json

          expect(response.status).to eq 200
          expect(response.body).to eq expected
        end
      end

      context 'with invalid attributes' do
        let!(:subscription) { create(:subscription, :on_question, subscriptable: question, user: user) }

        it 'does not add a new subscription to current_user' do
          expect { post :create, params: { question_id: question.id, subscriptable: 'questions' }, format: :json }
          .not_to change(user.subscriptions, :count)
        end

        it 'renders 422 with error messages' do
          expected = { errors: ['Subscriptable type has already been taken'] }.to_json

          post :create, params: { question_id: question.id, subscriptable: 'questions' }, format: :json
          expect(response.body).to eq expected
          expect(response.status).to eq 422
        end
      end
    end

    context 'Unauthenticated user tries to subscribe' do
      it 'does not change subscriptions number' do
        expect { post :create, params: { question_id: question.id, subscriptable: 'questions' }, format: :json }
        .not_to change(Subscription, :count)
      end

      it 'responses with code 403' do
        post :create, params: { question_id: question.id, subscriptable: 'questions' }, format: :json
        expect(response.status).to eq 403
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, :on_question, subscriptable: question, user: user) }

    context 'authorized' do
      before { login(user) }

      context 'with valid attributes' do
        it "deletes current_user's subscription" do
          expect { delete :destroy, params: { id: question, subscriptable: 'questions' }, format: :json }
          .to change(user.subscriptions, :count).by(-1)
        end

        it 'responses 200 with success message' do
          expected = { message: "Successfully unsubscribed" }.to_json

          delete :destroy, params: { id: question, subscriptable: 'questions' }, format: :json

          expect(response.status).to eq 200
          expect(response.body).to eq expected
        end
      end
    end

    context 'Unauthenticated user tries to subscribe' do
      it 'does not change subscriptions number' do
        expect { delete :destroy, params: { id: question, subscriptable: 'questions' }, format: :json }
        .not_to change(Subscription, :count)
      end

      it 'responses with code 403' do
        delete :destroy, params: { id: question, subscriptable: 'questions' }, format: :json
        expect(response.status).to eq 403
      end
    end
  end
end
