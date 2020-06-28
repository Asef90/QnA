require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }
  let(:me) { create(:user) }
  let(:my_access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:access_token) { create(:access_token) }
  let(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 4, question: question, author: me) }
  let(:answer) { answers.first }

  describe 'GET /api/v1/questions/:question_id/answers' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answers'].first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 4
      end

      it 'returns all public fields' do
        %w[id body author_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:links) { create_list(:link, 3, :for_answer, linkable: answer) }
      let!(:comments) { create_list(:comment, 4, :for_answer, commentable: answer) }
      # let(:file) { question.files.first }
      let(:answer_response) { json['answer'] }

      before do
        # question.files.attach(create_file_blob)
        get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns answer' do
        expect(answer_response['id']).to eq answer.id
      end

      it 'returns all public fields' do
        %w[id body author_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'returns links' do
        response_link_ids = []

        answer_response['links'].each do |link|
          response_link_ids << link['id']
        end

        expect(response_link_ids).to match_array Link.ids
      end

      it 'returns comments' do
        response_comment_ids = []

        answer_response['comments'].each do |comment|
          response_comment_ids << comment['id']
        end

        expect(response_comment_ids).to match_array Comment.ids
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
      let(:method) { :post }
    end

    context 'authorized' do
      before { post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token,
                                                                          answer: attributes_for(:answer) },
                                                                headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body author_id created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq assigns(:answer).send(attr).as_json
        end
      end
    end

    context 'with invalid params' do
      before { post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token,
                                                                          answer: attributes_for(:answer, :invalid) },
                                                                headers: headers }

      it 'returns 422 status' do
        expect(response.status).to eq 422
      end

      it "returns body can't be blank" do
        expect(json['errors'].first).to eq "Body can't be blank"
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :patch }
    end

    context 'authorized' do
      before { patch "/api/v1/answers/#{answer.id}", params: { access_token: my_access_token.token,
                                                               id: answer,
                                                               answer: { body: 'New body' } },
                                                     headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        answer.reload

        %w[id body author_id created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      it 'updates body' do
        answer.reload

        expect(answer.body).to eq 'New body'
      end
    end

    context 'not author of answer' do
      before { patch "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token,
                                                                   id: answer,
                                                                   answer: { body: 'New body' } },
                                                     headers: headers }

      it 'returns 403 status' do
       expect(response.status).to eq 403
      end

      it 'does not update body' do
        answer.reload

        expect(answer.body).not_to eq 'New body'
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :delete }
    end

    context 'authorized' do
      it 'returns 200 status' do
        delete "/api/v1/answers/#{answer.id}", params: { access_token: my_access_token.token, id: answer },
                                               headers: headers
        expect(response).to be_successful
      end

      it 'deletes answer' do
        expect { delete "/api/v1/answers/#{answer.id}", params: { access_token: my_access_token.token, id: answer },
                 headers: headers }.to change(Answer, :count).by(-1)
      end
    end

    context 'not author of answer' do
      it 'returns 403 status' do
        delete "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token, id: answer },
                                               headers: headers
        expect(response.status).to eq 403
      end

      it 'does not delete answer' do
        expect { delete "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token, id: answer },
                 headers: headers }.not_to change(Answer, :count)
      end
    end
  end
end
