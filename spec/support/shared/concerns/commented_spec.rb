require 'rails_helper'

shared_examples_for 'commented' do

  let(:user) { create(:user) }
  let(:commentable) { create(described_class.controller_name.classify.underscore.to_sym) }

  describe 'POST #create_comment' do
    context 'authorized' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new comment in the database' do
          expect { post :create_comment, params: { id: commentable.id, comment: attributes_for(:comment) }, format: :json }
          .to change(commentable.comments, :count).by(1)
        end

        it 'responses 204 no content' do
          post :create_comment, params: { id: commentable.id, comment: attributes_for(:comment) }, format: :json
          expect(response.status).to eq 204
        end
      end

      context 'with invalid attributes' do
        it 'does not save the comment' do
          expect { post :create_comment, params: { id: commentable.id, comment: attributes_for(:comment, :invalid) }, format: :json }
          .to_not change(commentable.comments, :count)
        end

        it 'renders errors json' do
          expected = { errors: ["Body can't be blank"] }.to_json

          post :create_comment, params: { id: commentable.id, comment: attributes_for(:comment, :invalid) }, format: :json
          expect(response.body).to eq expected
        end
      end
    end

    context 'Unauthenticated user tries to write comment' do
      it 'responses with code 403' do
        post :create_comment, params: { id: commentable.id, comment: attributes_for(:comment) }, format: :json
        expect(response.status).to eq 403
      end
    end
  end
end
