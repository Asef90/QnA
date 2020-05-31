require 'rails_helper'

RSpec.describe RewardsController, type: :controller do

  describe "GET #index" do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let!(:questions) { create_list(:question, 2, :with_reward, author: user) }


    before do
      questions.each { |question| another_user.give_reward(question.reward) }

      login(another_user)
      get :index
    end

    it "assigns all user's rewards to @questions" do
      expect(assigns(:rewards)).to match_array another_user.rewards
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
