require 'rails_helper'

feature 'User can create comment', %q{
  In order to clarify information
  As an authenticated user
  I'd like to be able to add comment to commentable resource
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe "Multiple sessions", js: true do
    scenario "comment to question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        click_on 'Add comment'

        within '.add-comment-form' do
          fill_in 'Body', with: 'Test comment'
          click_on 'Save'
        end

        expect(page).to have_content 'Test comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test comment'
      end
    end
  end

  describe "Multiple sessions", js: true do
    given!(:answer) { create(:answer, question: question, author: user) }

    scenario "comment to answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do
          click_on 'Add comment'
        end

        within '.answers' do
          fill_in 'Body', with: 'Test comment'
          click_on 'Save'
        end

        expect(page).to have_content 'Test comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test comment'
      end
    end
  end
end
