require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }

  it { should validate_presence_of :value }

  let(:user) { create(:user) }

  describe "uniqueness" do
    let!(:vote) { create(:vote, :for_question, user: user) }

    it { is_expected.to validate_uniqueness_of(:votable_type).ignoring_case_sensitivity.scoped_to(:votable_id, :user_id) }
  end

  describe "#process_vote" do
    let(:question) { create(:question, author: user) }
    let(:vote_up) { create(:vote, votable: question, user: user) }
    let(:vote_down) { create(:vote, :down, votable: question, user: user) }

    it 'adds vote if resource has no vote from specified user' do
      question.process_vote(user: user, value: 1)

      expect(question.votes_number).to eq 1
    end

    it 'resets votes if resource has opposite vote from specified user' do
      vote_down
      question.process_vote(user: user, value: 1)

      expect(question.votes_number).to eq 0
    end

    it 'does not add vote if resource has identical vote by value from specified user' do
      vote_up
      question.process_vote(user: user, value: 1)

      expect(question.votes_number).to eq 1
    end
  end
end
