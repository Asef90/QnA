require 'rails_helper'

feature 'User can create answer', %q{
  In order to help user to find best solution
  As an author of question
  I'd like to be able to choose best answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 3, question: question, author: another_user) }

  describe 'Authenticated user', js: true do
    scenario 'tries to choose the best answer to his question' do
      sign_in(user)
      visit question_path(question)

      second_answer = answers.second

      within "#answer-#{second_answer.id}" do
        click_on 'Best'
        expect(page).not_to have_link 'Best'
      end

      expect(first('.answer')).to have_content second_answer.body
    end

    scenario "tries to choose the best answer to another user's question", js: true do
      sign_in(another_user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Best'
      end
    end
  end

  scenario 'Unauthenticated user tries to choose the best answer to question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Best'
  end
end
