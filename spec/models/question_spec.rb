require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }

  it { should have_one(:reward).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :reward }

  it_behaves_like 'attachable'
  it_behaves_like 'authorable'
  it_behaves_like 'commentable'
  it_behaves_like 'linkable'
  it_behaves_like 'votable'
  it_behaves_like 'subscriptable'


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
end
