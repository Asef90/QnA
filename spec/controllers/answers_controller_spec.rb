require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }


  describe 'GET #show' do
    let(:answer) { create(:answer, question: question, author: user) }

    before{ login(user) }
    before { get :show, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
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
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question },
                               format: :js }.to change(question.answers, :count).by(1)
      end

      it 'associate answer with its author' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer).author).to eq user
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

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, author: user) }
    before{ login(user) }

    context 'with valid attributes' do
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

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer.reload, :body)
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'authenticated user is an author' do
      before{ login(user) }

      it 'deletes answer from the database' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to assigns(:answer).question
      end
    end

    context 'authenticated user is not an author' do
      let(:another_user) { create(:user) }

      before{ login(another_user) }

      it 'does not delete answer from the database' do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
      end

      it 'redirects to sign in view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to assigns(:answer).question
      end
    end

    context 'unauthenticated user' do
      it 'does not delete answer from the database' do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
      end

      it 'redirects to sign in view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
