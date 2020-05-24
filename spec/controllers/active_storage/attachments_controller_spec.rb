require 'rails_helper'

RSpec.describe ActiveStorage::AttachmentsController, type: :controller do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe "DELETE #destroy" do
    before { question.files.attach(create_file_blob) }
    let!(:file) { question.files.first }

    context 'authenticated user is an author' do
      before { login(user) }

      it 'deletes file from the database' do
        expect { delete :destroy, params: { id: file }, format: :js }.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: file }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'authenticated user is not an author' do
      before{ login(another_user) }

      it 'does not delete file from the database' do
        expect { delete :destroy, params: { id: file }, format: :js }.not_to change(ActiveStorage::Attachment, :count)
      end

      it 'renders no roots template' do
        delete :destroy, params: { id: file }, format: :js
        expect(response).to render_template 'shared/_no_roots'
      end
    end

    context 'unauthenticated user' do
      it 'does not delete file from the database' do
        expect { delete :destroy, params: { id: file } }.not_to change(Answer, :count)
      end

      it 'responses with code 401'
    end
  end
end
