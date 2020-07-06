require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'commented'
  it_behaves_like 'voted'

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'GET #show' do
    let(:answer) { create(:answer, question: question, author: user) }

    before{ login(user) }
    before { get :show, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end
  end

  describe 'GET #new' do
    before{ login(user) }
    before { get :new, params: { question_id: question } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'Authenticated user tries to create answer' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question },
                                 format: :js }.to change(question.answers, :count).by(1)
        end

        it 'associates answer with its author' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
          expect(assigns(:answer).author).to eq user
        end

        it 'calls QuestionSubscribersJob' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }
                                 .to have_enqueued_job(QuestionSubscribersJob)
        end

        it 'renders create template' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) },
                                 format: :js }.to_not change(question.answers, :count)
        end

        it 'renders create template' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'Unauthenticated user tries to create answer' do
      it 'does not save the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) },
                               format: :js }.to_not change(question.answers, :count)
      end

      it 'responses with code 401'
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'Authenticated user' do
      before{ login(user) }

      context 'tries to update answer with valid attributes' do
        it 'changes answer attributes'do
          patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update template' do
          patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'tries to update answer with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update template' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end

      context "tries to update another user's answer" do
        before { login(another_user) }
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders no roots template' do
          patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
          expect(response).to render_template 'shared/_no_roots'
        end
      end
    end

    context 'Unauthenticated user tries to update answer' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
        end.to_not change(answer, :body)
      end

      it 'responses with code 401'
    end
  end

  describe 'PATCH #set_best' do
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'Authenticated user' do
      let!(:reward) { create(:reward, question: question) }

      context 'tries to set best mark to answer to his question' do
        before do
          login(user)
          patch :set_best, params: { id: answer }, format: :js
        end

        it 'sets best mark to @answer' do
          expect(assigns(:answer)).to be_best
        end

        it 'adds reward to author of answer' do
          expect(assigns(:answer).author.rewards.first).to eq reward
        end

        it 'renders set_best template' do
          expect(response).to render_template :set_best
        end
      end

      context "tries to set best mark to answer to another user's question" do
        before do
          login(another_user)
          patch :set_best, params: { id: answer }, format: :js
        end

        it 'does not set best mark to @answer' do
          expect(assigns(:answer)).not_to be_best
        end

        it 'renders no roots template' do
          expect(response).to render_template 'shared/_no_roots'
        end
      end
    end

    context 'Unauthenticated user tries to set best mark to answer to question' do
      before { patch :set_best, params: { id: answer }, format: :js }

      it 'does not set best mark to @answer' do
        expect(answer.reload).not_to be_best
      end

      it 'responses with code 401'
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'authenticated user is an author' do
      before{ login(user) }

      it 'deletes answer from the database' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'authenticated user is not an author' do
      before{ login(another_user) }

      it 'does not delete answer from the database' do
        expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
      end

      it 'renders no roots template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template 'shared/_no_roots'
      end
    end

    context 'unauthenticated user' do
      it 'does not delete answer from the database' do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
      end

      it 'responses with code 401'
    end
  end
end
