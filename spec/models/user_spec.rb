require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author?' do
    let(:users) { create_list(:user, 2) }
    let(:question) { create(:question, author: users.first) }

    it 'should return true if user is an author of the resource' do
      expect(users.first).to be_author(question)
    end

    it 'should return false if user is not an author of the resource' do
      expect(users.second).not_to be_author(question)
    end
  end
end
