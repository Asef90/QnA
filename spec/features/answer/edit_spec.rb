require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user', js: true do
    describe 'tries to edit his answer' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'with correct params' do
        within '.answers' do
          click_on 'Edit'
          fill_in 'Body', with: 'Edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'Edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'with files adding' do
        within '.answers' do
          click_on 'Edit'
          fill_in 'Body', with: 'Edited answer'
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          sleep(10)

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'with links adding' do
        within '.answers' do
          click_on 'Edit'

          click_on 'add link'

          fill_in 'Link name', with:'example'
          fill_in 'Url', with: 'https://www.example.com'

          click_on 'Save'

          expect(page).to have_link 'example', href: 'https://www.example.com'
        end
      end

      scenario 'with errors' do
        within '.answers' do
          click_on 'Edit'
          fill_in 'Body', with: ''
          click_on 'Save'

          expect(page).to have_content "Body can't be blank"
        end
      end
    end

    scenario "tries to edit another user's answer" do
      sign_in(another_user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user can not edit answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
