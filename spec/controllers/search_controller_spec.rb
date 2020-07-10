require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #index" do

    context 'global search' do
      it "calls ThinkingSphinx" do
        expect(ThinkingSphinx).to receive(:search).with('test')
        get :index, params: { area: 'All', query: 'test' }
      end

      it 'renders index view' do
        allow(ThinkingSphinx).to receive(:search).with('test')
        get :index, params: { area: 'All', query: 'test' }
        expect(response).to render_template :index
      end
    end

    context 'answers search' do
      it "calls ThinkingSphinx" do
        expect(Answer).to receive(:search).with('test')
        get :index, params: { area: 'Answer', query: 'test' }
      end

      it 'renders index view' do
        allow(Answer).to receive(:search).with('test')
        get :index, params: { area: 'Answer', query: 'test' }
        expect(response).to render_template :index
      end
    end

    context 'comments search' do
      it "calls ThinkingSphinx" do
        expect(Comment).to receive(:search).with('test')
        get :index, params: { area: 'Comment', query: 'test' }
      end

      it 'renders index view' do
        allow(Comment).to receive(:search).with('test')
        get :index, params: { area: 'Comment', query: 'test' }
        expect(response).to render_template :index
      end
    end

    context 'questions search' do
      it "calls ThinkingSphinx" do
        expect(Question).to receive(:search).with('test')
        get :index, params: { area: 'Question', query: 'test' }
      end

      it 'renders index view' do
        allow(Question).to receive(:search).with('test')
        get :index, params: { area: 'Question', query: 'test' }
        expect(response).to render_template :index
      end
    end

    context 'users search' do
      it "calls ThinkingSphinx" do
        expect(User).to receive(:search).with('test')
        get :index, params: { area: 'User', query: 'test' }
      end

      it 'renders index view' do
        allow(User).to receive(:search).with('test')
        get :index, params: { area: 'User', query: 'test' }
        expect(response).to render_template :index
      end
    end
  end
end
