require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    scenario 'tries to edit his question' do
      sign_in(user)
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: 'Edited title'
        fill_in 'Body', with: 'Edited body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited title'
        expect(page).to have_content 'Edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit his question with errors' do
      sign_in(user)
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
      end
    end

    scenario "tries to edit another user's answer" do
      sign_in(another_user)
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user can not edit answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
