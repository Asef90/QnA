require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to :subscriptable }
  it { should belong_to :user }

  describe "uniqueness" do
    let!(:subscription) { create(:subscription, :on_question) }

    it { is_expected.to validate_uniqueness_of(:subscriptable_type).ignoring_case_sensitivity.scoped_to(:subscriptable_id, :user_id) }
  end
end
