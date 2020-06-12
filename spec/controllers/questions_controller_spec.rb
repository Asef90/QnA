require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, author: user) }

    before { get :index }

    it 'assigns all questions to @questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end

  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new link for @answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new link for @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new reward for @question' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end

  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(user.questions, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #vote_up' do
    context 'Authenticated user' do
      context "tries to vote up for another user's question" do
        before do
          login(another_user)
        end

        it 'adds vote to question if voted up' do
          expect { post :vote_up, params: { id: question }, format: :json }.to change(question.votes, :count).by(1)
        end

        it 'does not add second vote to question if voted up from the same user' do
          expect do
            2.times { post :vote_up, params: { id: question, value: 1 }, format: :json }
          end.to change(question.votes, :count).by(1)
        end

        it 'removes vote from question if voted up with an existing down vote from the same user' do
          Vote.create(user_id: another_user.id, votable: question, value: -1)

          expect { post :vote_up, params: { id: question }, format: :json }.to change(question.votes, :count).by(-1)
        end

        it 'renders json response with question id, class name and votes number' do
          expected = { id: question.id, type: "Question", number: question.votes_number + 1 }.to_json

          post :vote_up, params: { id: question }, format: :json
          expect(response.body).to eq expected
        end
      end

      context "tries to vote for his question" do
        before do
          login(user)
        end

        it 'does not adds vote to question if voted up' do
          expect { post :vote_up, params: { id: question }, format: :json }.not_to change(question.votes, :count)
        end

        it 'renders No roots' do
          post :vote_up, params: { id: question }, format: :json
          expect(response.body).to eq "No roots"
        end
      end
    end

    context 'Unauthenticated user tries to vote up for question' do
      it 'responses with code 401'
    end
  end

  describe 'POST #vote_down' do
    context 'Authenticated user' do
      context "tries to vote down for another user's question" do
        before do
          login(another_user)
        end

        it 'adds vote to question if voted down' do
          expect { post :vote_down, params: { id: question }, format: :json }.to change(question.votes, :count).by(1)
        end

        it 'does not add second vote to question if voted down from the same user' do
          expect do
            2.times { post :vote_down, params: { id: question }, format: :json }
          end.to change(question.votes, :count).by(1)
        end

        it 'removes vote from question if voted down with an existing up vote from the same user' do
          Vote.create(user_id: another_user.id, votable: question, value: 1)

          expect { post :vote_down, params: { id: question }, format: :json }.to change(question.votes, :count).by(-1)
        end

        it 'renders json response with question id, class name and votes number' do
          expected = { id: question.id, type: "Question", number: question.votes_number - 1 }.to_json

          post :vote_down, params: { id: question }, format: :json
          expect(response.body).to eq expected
        end
      end

      context "tries to vote down for his question" do
        before do
          login(user)
        end

        it 'does not adds vote to question if voted down' do
          expect { post :vote_down, params: { id: question }, format: :json }.not_to change(question.votes, :count)
        end

        it 'renders No roots' do
          post :vote_down, params: { id: question }, format: :json
          expect(response.body).to eq "No roots"
        end
      end
    end

    context 'Unauthenticated user tries to vote for question' do
      it 'responses with code 401'
    end
  end

  describe 'POST #create_comment' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new comment in the database' do
        expect { post :create_comment, params: { id: question.id, comment: attributes_for(:comment) }, format: :json }
        .to change(question.comments, :count).by(1)
      end

      it 'responses 204 no content' do
        post :create_comment, params: { id: question.id, comment: attributes_for(:comment) }, format: :json
        expect(response.code).to eq "204"
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect { post :create_comment, params: { id: question.id, comment: attributes_for(:comment, :invalid) }, format: :json }
        .to_not change(question.comments, :count)
      end

      it 'renders errors json' do
        expected = { errors: ["Body can't be blank"] }.to_json

        post :create_comment, params: { id: question.id, comment: attributes_for(:comment, :invalid) }, format: :json
        expect(response.body).to eq expected
      end
    end

    context 'Unauthenticated user tries to vote up for question' do
      it 'responses with code 401'
    end
  end

  describe 'PATCH #update' do
    context 'Authenticated user' do
      before { login(user) }

      context 'tries to update his question with valid attributes' do
        before do
          patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }, format: :js
        end

        it 'changes question attributes' do
          question.reload

          expect(question.title).to eq 'New title'
          expect(question.body).to eq 'New body'
        end

        it 'renders update template' do
          expect(response).to render_template :update
        end
      end

      context 'tries to update his question with invalid attributes' do
        it 'does not change question attributes' do
          expect do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          end.to_not change(question, :title)
          expect do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          end.to_not change(question, :body)
        end

        it 'renders update template' do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end

      context "tries to update another user's question" do
        before { login(another_user) }
        it 'does not change question attributes' do
          expect do
            patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }, format: :js
          end.to_not change(question, :title)
          expect do
            patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }, format: :js
          end.to_not change(question, :body)
        end

        it 'renders no_roots template' do
          patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }, format: :js
          expect(response).to render_template 'shared/_no_roots'
        end
      end
    end

    context 'Unauthenticated user tries to update question' do
      it 'does not change question attributes' do
        expect do
          patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }, format: :js
        end.to_not change(question, :title)
        expect do
          patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }, format: :js
        end.to_not change(question, :body)
      end

      it 'responses with code 401'
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, author: user) }

    context 'authenticated user is an author' do
      before { login(user) }

      it 'deletes question from the database' do
        expect { delete :destroy, params: { id: question } }.to change(user.questions, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'authenticated user is not an author' do
      let(:another_user) { create(:user) }

      before { login(another_user) }

      it 'does not delete question from the database' do
        expect { delete :destroy, params: { id: question } }.not_to change(user.questions, :count)
      end

      it 'redirects to sign in view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'unauthenticated user' do
      it 'does not delete question from the database' do
        expect { delete :destroy, params: { id: question } }.not_to change(user.questions, :count)
      end

      it 'redirects to sign in view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
