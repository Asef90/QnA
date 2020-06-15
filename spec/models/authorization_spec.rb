require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to(:user).optional(true) }

  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }

  describe "uniqueness" do
    it { is_expected.to validate_uniqueness_of(:provider).scoped_to(:uid) }
  end
end
