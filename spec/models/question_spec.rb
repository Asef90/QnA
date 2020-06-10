require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should belong_to :author }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe '#with_reward?' do
    let(:question_with_reward) { create(:question, :with_reward, author: user) }

    it 'should return true if question with reward' do
      expect(question_with_reward).to be_with_reward
    end

    it 'should return false if question without reward' do
      expect(question).not_to be_with_reward
    end
  end

  describe "#votes_number" do
    let(:another_user) { create(:user) }
    let!(:vote) { create(:vote, votable: question, user: user) }
    let!(:second_vote) { create(:vote, votable: question, user: another_user) }

    it 'should return 2' do
      expect(question.votes_number).to equal 2
    end
  end
end
