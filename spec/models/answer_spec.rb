require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :author }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:best_answer) { create(:answer, question: question, author: user, best_mark: true) }
  let!(:answer) { create(:answer, question: question, author: user) }

  describe '#set_best_mark' do
    before { answer.set_best_mark }

    it 'sets best mark to answer' do
      expect(answer.reload).to be_best
    end

    it 'resets the previous best answer' do
      expect(best_answer.reload).not_to be_best
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
