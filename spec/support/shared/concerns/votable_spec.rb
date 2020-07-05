require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:votable) { create(described_class.to_s.underscore.to_sym, author: user) }

  describe "#votes_number" do
    let!(:vote) { create(:vote, votable: votable, user: user) }
    let!(:second_vote) { create(:vote, votable: votable, user: create(:user)) }

    it 'should return 2' do
      expect(votable.votes_number).to equal 2
    end
  end

  describe "#process_vote" do
    let(:vote_up) { create(:vote, votable: votable, user: user) }
    let(:vote_down) { create(:vote, :down, votable: votable, user: user) }

    it 'adds vote if votable has no vote from specified user' do
      votable.process_vote(user: user, value: 1)

      expect(votable.votes_number).to eq 1
    end

    it 'resets votes if votable has opposite vote from specified user' do
      vote_down
      votable.process_vote(user: user, value: 1)

      expect(votable.votes_number).to eq 0
    end

    it 'does not add vote if votable has identical vote by value from specified user' do
      vote_up
      votable.process_vote(user: user, value: 1)

      expect(votable.votes_number).to eq 1
    end
  end
end
