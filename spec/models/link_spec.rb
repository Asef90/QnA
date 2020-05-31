require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('https://www.yandex.ru').for(:url) }
  it { should_not allow_value('htts://www.yandex.ru').for(:url) }

  describe '#gist_link?' do
    let(:question) { create(:question) }
    let(:gist_link) { create(:link, linkable: question, url: 'https://gist.github.com/Asef90/a22d4e70429275c852cfef89cbb0c8f5') }
    let(:another_link) { create(:link, linkable: question, url: 'https://www.yandex.ru') }

    it 'should return true if link is a gist link' do
      expect(gist_link).to be_gist_link
    end

    it 'should return false if user is not an author of the resource' do
      expect(another_link).not_to be_gist_link
    end
  end
end
