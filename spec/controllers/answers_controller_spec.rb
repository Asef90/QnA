require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }


  describe 'GET #show' do
    let(:answer) { create(:answer, question: question, author: user) }

    before{ login(user) }
    before { get :show, params: { question_id: question, id: answer } }

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
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question_id: question,
                                         answer: attributes_for(:answer, :invalid) } }.to_not change(question.answers, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'authenticated user is an author' do
      before{ login(user) }

      it 'deletes answer from the database' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to question show index view' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to assigns(:answer).question
      end
    end

    context 'authenticated user is not an author' do
      let(:another_user) { create(:user) }

      before{ login(another_user) }

      it 'does not delete answer from the database' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.not_to change(question.answers, :count)
      end
    end

    context 'unauthenticated user' do
      it 'does not delete answer from the database' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.not_to change(question.answers, :count)
      end
    end
  end
end
