require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question, author: users.first) }

  describe '.from_omniauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)

      User.from_omniauth(auth)
    end
  end

  describe '#author?' do
    it 'should return true if user is an author of the resource' do
      expect(users.first).to be_author(question)
    end

    it 'should return false if user is not an author of the resource' do
      expect(users.second).not_to be_author(question)
    end
  end

  describe '#give_reward?' do
    let(:reward) { create(:reward, question: question)}

    it 'should increase users rewards by one' do
      expect { users.second.give_reward(reward) }.to change(users.second.rewards, :count).by(1)
    end

    it 'should add to users rewards given one' do
      users.second.give_reward(reward)

      expect(users.second.rewards.last).to eq reward
    end
  end
end
