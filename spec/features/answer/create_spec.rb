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

    scenario 'tries write an answer with attached files' do
      fill_in 'Body', with: 'Test body'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"], id: 'create-answer-filefield'
      click_on 'Create answer'

      sleep(10)

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'tries write an answer with errors' do
      click_on 'Create answer'

      within '.answer-create-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe "Multiple sessions", js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'Test answer'
        click_on 'Create answer'

        expect(page).to have_content 'Test answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test answer'
      end
    end
  end

  scenario 'Unauthenticated user tries write an answer' do
    visit question_path(question)

    expect(page).not_to have_button 'Create answer'
  end
end
