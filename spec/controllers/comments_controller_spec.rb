require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    context 'to questions' do
      context 'authorized' do
        before { login(user) }

        context 'with valid attributes' do
          it 'saves a new comment in the database' do
            expect { post :create, params: { question_id: question.id, comment: attributes_for(:comment), commentable: 'questions' },
                                   format: :json }
            .to change(question.comments, :count).by(1)
          end

          it 'responses 204 no content' do
            post :create, params: { question_id: question.id, comment: attributes_for(:comment), commentable: 'questions' },
                          format: :json
            expect(response.status).to eq 204
          end
        end

        context 'with invalid attributes' do
          it 'does not save the comment' do
            expect { post :create, params: { question_id: question.id, comment: attributes_for(:comment, :invalid), commentable: 'questions' },
                                   format: :json }
            .to_not change(question.comments, :count)
          end

          it 'renders errors json' do
            expected = { errors: ["Body can't be blank"] }.to_json

            post :create, params: { question_id: question.id, comment: attributes_for(:comment, :invalid), commentable: 'questions' },
                          format: :json
            expect(response.body).to eq expected
          end
        end
      end

      context 'Unauthenticated user tries to write comment' do
        it 'responses with code 403' do
          post :create, params: { question_id: question.id, comment: attributes_for(:comment), commentable: 'questions' },
                        format: :json
          expect(response.status).to eq 403
        end
      end
    end

    context 'to answers' do
      context 'authorized' do
        before { login(user) }

        context 'with valid attributes' do
          it 'saves a new comment in the database' do
            expect { post :create, params: { answer_id: answer.id, comment: attributes_for(:comment), commentable: 'answers' },
                                   format: :json }
            .to change(answer.comments, :count).by(1)
          end

          it 'responses 204 no content' do
            post :create, params: { answer_id: answer.id, comment: attributes_for(:comment), commentable: 'answers' },
                          format: :json
            expect(response.status).to eq 204
          end
        end

        context 'with invalid attributes' do
          it 'does not save the comment' do
            expect { post :create, params: { answer_id: answer.id, comment: attributes_for(:comment, :invalid), commentable: 'answers' },
                                   format: :json }
            .to_not change(answer.comments, :count)
          end

          it 'renders errors json' do
            expected = { errors: ["Body can't be blank"] }.to_json

            post :create, params: { answer_id: answer.id, comment: attributes_for(:comment, :invalid), commentable: 'answers' },
                          format: :json
            expect(response.body).to eq expected
          end
        end
      end

      context 'Unauthenticated user tries to write comment' do
        it 'responses with code 403' do
          post :create, params: { answer_id: answer.id, comment: attributes_for(:comment), commentable: 'answers' },
                        format: :json
          expect(response.status).to eq 403
        end
      end
    end
  end
end
