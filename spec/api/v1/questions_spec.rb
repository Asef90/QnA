require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }
  let(:me) { create(:user) }
  let(:my_access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:access_token) { create(:access_token) }
  let!(:questions) { create_list(:question, 2, author: me) }
  let(:question) { questions.first }


  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/questions' }
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      describe 'answers' do
      let(:answer) { answers.first }
      let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:links) { create_list(:link, 3, :for_question, linkable: question) }
      let!(:comments) { create_list(:comment, 4, :for_question, commentable: question) }
      # let(:file) { question.files.first }
      let(:question_response) { json['question'] }

      before do
        # question.files.attach(create_file_blob)
        get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'returns links' do
        response_link_ids = []

        question_response['links'].each do |link|
          response_link_ids << link['id']
        end

        expect(response_link_ids).to match_array Link.ids
      end

      it 'returns comments' do
        response_comment_ids = []

        question_response['comments'].each do |comment|
          response_comment_ids << comment['id']
        end

        expect(response_comment_ids).to match_array Comment.ids
      end
    end
  end

  describe 'POST /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/questions' }
      let(:method) { :post }
    end

    context 'authorized' do
      before { post '/api/v1/questions', params: { access_token: access_token.token,
                                                   question: attributes_for(:question) },
                                         headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title author_id body created_at updated_at].each do |attr|
          expect(json['question'][attr]).to eq assigns(:question).send(attr).as_json
        end
      end
    end

    context 'with invalid params' do
      before { post '/api/v1/questions', params: { access_token: access_token.token,
                                                   question: attributes_for(:question, :invalid) },
                                         headers: headers }

      it 'returns 422 status' do
        expect(response.status).to eq 422
      end

      it "returns title can't be blank" do
        expect(json['errors'].first).to eq "Title can't be blank"
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :patch }
    end

    context 'authorized' do
      before { patch "/api/v1/questions/#{question.id}", params: { access_token: my_access_token.token,
                                                                   id: question,
                                                                   question: { body: 'New body', title: 'New title' } },
                                                         headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        question.reload

        %w[id title author_id body created_at updated_at].each do |attr|
          expect(json['question'][attr]).to eq question.send(attr).as_json
        end
      end

      it 'updates body and title' do
        question.reload

        expect(question.body).to eq 'New body'
        expect(question.title).to eq 'New title'
      end
    end

    context 'not author of question' do
      before { patch "/api/v1/questions/#{question.id}", params: { access_token: access_token.token,
                                                                   id: question,
                                                                   question: { body: 'New body', title: 'New title' } },
                                                         headers: headers }

      it 'returns 403 status' do
       expect(response.status).to eq 403
      end

      it 'does not update body and title' do
        question.reload

        expect(question.body).not_to eq 'New body'
        expect(question.title).not_to eq 'New title'
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :delete }
    end

    context 'authorized' do
      it 'returns 200 status' do
        delete "/api/v1/questions/#{question.id}", params: { access_token: my_access_token.token, id: question },
                                                   headers: headers
        expect(response).to be_successful
      end

      it 'deletes question' do
        expect { delete "/api/v1/questions/#{question.id}", params: { access_token: my_access_token.token, id: question },
                 headers: headers }.to change(Question, :count).by(-1)
      end
    end

    context 'not author of question' do
      it 'returns 403 status' do
        delete "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, id: question },
                                                   headers: headers
        expect(response.status).to eq 403
      end

      it 'does not delete question' do
        expect { delete "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, id: question },
                 headers: headers }.not_to change(Question, :count)
      end
    end
  end
end
