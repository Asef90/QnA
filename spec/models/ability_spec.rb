require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:another_question) { create(:question, author: another_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, Question }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    it { should be_able_to :create_comment, Question }
    it { should be_able_to :create_comment, Answer }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, another_question }

    it { should be_able_to :update, create(:answer, author: user) }
    it { should_not be_able_to :update, create(:answer, author: another_user) }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, another_question }

    it { should be_able_to :destroy, create(:answer, author: user) }
    it { should_not be_able_to :destroy, create(:answer, author: another_user) }

    it { should be_able_to :set_best, create(:answer, question: question) }
    it { should_not be_able_to :set_best, create(:answer, question: another_question) }

    it { should be_able_to :vote_up, another_question }
    it { should_not be_able_to :vote_up, question }
    it { should be_able_to :vote_down, another_question }
    it { should_not be_able_to :vote_down, question }

    it { should be_able_to :vote_up, create(:answer, author: another_user) }
    it { should_not be_able_to :vote_up, create(:answer, author: user) }
    it { should be_able_to :vote_down, create(:answer, author: another_user) }
    it { should_not be_able_to :vote_down, create(:answer, author: user) }

    it { should be_able_to :index, create(:reward, user: user) }
    it { should_not be_able_to :index, create(:reward, user: another_user) }

    it { should be_able_to :destroy, create(:link, :for_question, linkable: question) }
    it { should_not be_able_to :destroy, create(:link, :for_question, linkable: another_question) }

    describe 'files deleting' do
      before { question.files.attach(create_file_blob) }
      before { another_question.files.attach(create_file_blob) }
      let(:attachment) { question.files.first }
      let(:another_attachment) { another_question.files.first }

      it { should be_able_to :destroy, attachment }
      it { should_not be_able_to :destroy, another_attachment }
    end
  end
end
