require 'rails_helper'

feature 'User can delete his question', %q{
  In order to manage with my data
  As an authenticated user
  I'd like to be able to delete my question
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }

  given(:question1) { create(:question, author: user1) }
  given(:question2) { create(:question, author: user2) }

  describe 'Authenticated user' do
    background { sign_in(user1) }

    scenario 'tries to delete his question' do
      visit question_path(question1)
      click_on 'Delete question'

      expect(page).to have_content 'Your question successfully deleted.'
      expect(page).not_to have_content(question1.title)
    end

    scenario "tries to delete another's question" do
      visit question_path(question2)

      expect(page).not_to have_link 'Delete question'
    end
  end


  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question1)

    expect(page).not_to have_link 'Delete question'
  end
end
