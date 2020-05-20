require 'rails_helper'

feature 'User can create answer', %q{
  In order to help solve the problem
  As an authenticated user
  I'd like to be able to answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'tries write an answer' do
      fill_in 'Body', with: 'Test body'
      click_on 'Create answer'

      expect(page).to have_content 'Test body'
    end

    scenario 'tries write an answer with errors' do
      click_on 'Create answer'

      within '.answer-create-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user tries write an answer' do
    visit question_path(question)
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
