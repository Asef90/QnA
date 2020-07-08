require 'rails_helper'

shared_examples_for 'subscriptable' do
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions) }

  describe '#has_subscription_from?' do
    let(:subscriber) { create(:user) }
    let(:not_subscriber) { create(:user) }
    let(:subscriptable) { create(described_class.to_s.underscore.to_sym) }
    let!(:subscription) { create(:subscription, :on_question, subscriptable: subscriptable, user: subscriber) }

    it 'returns true for subscriber' do
      expect(subscriptable.has_subscription_from?(subscriber)).to be_truthy
    end

    it 'returns false for not subscriber' do
      expect(subscriptable.has_subscription_from?(not_subscriber)).to be_falsey
    end
  end
end
