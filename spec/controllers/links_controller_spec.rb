require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:link) { create(:link, :for_question, linkable: question) }

  describe "DELETE #destroy" do

    context 'authenticated user is an author of the resource' do
      before { login(user) }

      it 'deletes link from the database' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'authenticated user is not an author' do
      before{ login(another_user) }

      it 'does not delete link from the database' do
        expect { delete :destroy, params: { id: link }, format: :js }.not_to change(Link, :count)
      end

      it 'renders no roots template' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template 'shared/_no_roots'
      end
    end

    context 'unauthenticated user' do
      it 'does not delete link from the database' do
        expect { delete :destroy, params: { id: link } }.not_to change(Link, :count)
      end

      it 'responses with code 401'
    end
  end

end
