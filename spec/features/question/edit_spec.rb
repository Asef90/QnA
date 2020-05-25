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
    describe 'tries to edit his question' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'with correct params' do
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

      scenario 'with files adding' do
        within '.question' do
          click_on 'Edit'
          fill_in 'Title', with: 'Edited title'
          fill_in 'Body', with: 'Edited body'
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'with errors' do
        within '.question' do
          click_on 'Edit'
          fill_in 'Title', with: ''
          click_on 'Save'

          expect(page).to have_content "Title can't be blank"
        end
      end
    end

    scenario "tries to edit another user's question" do
      sign_in(another_user)
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user can not edit question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
