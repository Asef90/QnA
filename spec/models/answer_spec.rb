require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }

  it { should validate_presence_of :body }

  it_behaves_like 'attachable'
  it_behaves_like 'authorable'
  it_behaves_like 'commentable'
  it_behaves_like 'linkable'
  it_behaves_like 'votable'

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, :with_reward, author: user) }
  let!(:best_answer) { create(:answer, question: question, author: user, best_mark: true) }
  let!(:answer) { create(:answer, question: question, author: another_user) }

  describe '#set_best_mark' do
    context 'with before method call' do
      before { answer.set_best_mark }

      it 'sets best mark to answer' do
        expect(answer.reload).to be_best
      end

      it 'resets the previous best answer' do
        expect(best_answer.reload).not_to be_best
      end

      it 'gives reward to author of best answer' do
        expect(another_user.rewards.first).to eq question.reward
      end

      it 'does not change rewards of the author if answer already was the best' do
        expect { answer.set_best_mark }.not_to change(another_user.rewards, :count)
      end
    end

    it "changes rewards of the author if answer wasn't the best" do
      expect { answer.set_best_mark }.to change(another_user.rewards, :count).by(1)
    end
  end

  describe '#best?' do
    it 'should return true if answer has best mark' do
      expect(best_answer).to be_best
    end

    it 'should return false if answer has not best mark' do
      expect(answer).not_to be_best
    end
  end
end
