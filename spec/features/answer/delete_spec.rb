require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to manage with my answers
  As an authenticated user
  I'd like to be able to delete my answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    given(:answered_user) { create(:user) }
    given!(:answer) { create(:answer, author: answered_user, question: question) }

    scenario 'tries to delete his answer' do
      sign_in(answered_user)
      visit question_path(question)

      click_on 'Delete answer'

      expect(page).to have_content 'Your answer successfully deleted.'
      expect(page).not_to have_content(answer.body)
    end

    scenario "tries to delete another user's answer" do
      sign_in(user)

      visit question_path(question)
      expect(page).not_to have_content 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Delete answer'
  end
end
