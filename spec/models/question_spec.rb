require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should belong_to :author }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#with_reward?' do
    let(:user) { create(:user) }
    let(:question_with_reward) { create(:question, :with_reward, author: user) }
    let(:question_without_reward) { create(:question, author: user) }

    it 'should return true if question with reward' do
      expect(question_with_reward).to be_with_reward
    end

    it 'should return false if question without reward' do
      expect(question_without_reward).not_to be_with_reward
    end
  end
end
