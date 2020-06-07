require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }

  it { should validate_presence_of :value }

  describe "uniqueness" do
    before do
      user = create(:user)
      create(:vote, :for_question, user: user)
    end

    it { is_expected.to validate_uniqueness_of(:votable_type).ignoring_case_sensitivity.scoped_to(:votable_id, :user_id) }
  end
end
