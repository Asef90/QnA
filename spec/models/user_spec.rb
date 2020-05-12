require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'should confirm autorship' do
    users = create_list(:user, 2)
    question = create(:question, author: users.first)

    expect(users.first.author?(question)).to be_truthy
    expect(users.second.author?(question)).to be_falsey
  end
end
