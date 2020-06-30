require 'rails_helper'

shared_examples_for 'voted' do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:votable) { create(described_class.controller_name.classify.underscore.to_sym, author: user) }

  describe 'POST #vote_up' do
    context 'Authenticated user' do
      context "tries to vote up for another user's votable" do
        before do
          login(another_user)
        end

        it 'adds vote to votable if voted up' do
          expect { post :vote_up, params: { id: votable }, format: :json }.to change(votable.votes, :count).by(1)
        end

        it 'does not add second vote to votable if voted up from the same user' do
          expect do
            2.times { post :vote_up, params: { id: votable, value: 1 }, format: :json }
          end.to change(votable.votes, :count).by(1)
        end

        it 'removes vote from votable if voted up with an existing down vote from the same user' do
          Vote.create(user_id: another_user.id, votable: votable, value: -1)

          expect { post :vote_up, params: { id: votable }, format: :json }.to change(votable.votes, :count).by(-1)
        end

        it 'renders json response with votable id, class name and votes number' do
          expected = { id: votable.id, type: votable.class.name, number: votable.votes_number + 1 }.to_json

          post :vote_up, params: { id: votable }, format: :json
          expect(response.body).to eq expected
        end
      end

      context "tries to vote for his votable" do
        before do
          login(user)
        end

        it 'does not adds vote to votable if voted up' do
          expect { post :vote_up, params: { id: votable }, format: :json }.not_to change(votable.votes, :count)
        end

        it 'renders No roots' do
          post :vote_up, params: { id: votable }, format: :json
          expect(response.body).to eq "No roots"
        end
      end
    end

    context 'Unauthenticated user tries to vote up for votable' do
      it 'responses with code 403' do
        post :vote_up, params: { id: votable }, format: :json
        expect(response.status).to eq 403
      end
    end
  end

  describe 'POST #vote_down' do
    context 'Authenticated user' do
      context "tries to vote down for another user's votable" do
        before do
          login(another_user)
        end

        it 'adds vote to votable if voted down' do
          expect { post :vote_down, params: { id: votable }, format: :json }.to change(votable.votes, :count).by(1)
        end

        it 'does not add second vote to votable if voted down from the same user' do
          expect do
            2.times { post :vote_down, params: { id: votable }, format: :json }
          end.to change(votable.votes, :count).by(1)
        end

        it 'removes vote from votable if voted down with an existing up vote from the same user' do
          Vote.create(user_id: another_user.id, votable: votable, value: 1)

          expect { post :vote_down, params: { id: votable }, format: :json }.to change(votable.votes, :count).by(-1)
        end

        it 'renders json response with votable id, class name and votes number' do
          expected = { id: votable.id, type: votable.class.name, number: votable.votes_number - 1 }.to_json

          post :vote_down, params: { id: votable }, format: :json
          expect(response.body).to eq expected
        end
      end

      context "tries to vote down for his votable" do
        before do
          login(user)
        end

        it 'does not adds vote to votable if voted down' do
          expect { post :vote_down, params: { id: votable }, format: :json }.not_to change(votable.votes, :count)
        end

        it 'renders No roots' do
          post :vote_down, params: { id: votable }, format: :json
          expect(response.body).to eq "No roots"
        end
      end
    end

    context 'Unauthenticated user tries to vote for votable' do
      it 'responses with code 401' do
        post :vote_down, params: { id: votable }, format: :json
        expect(response.status).to eq 403
      end
    end
  end

end
