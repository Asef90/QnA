require 'rails_helper'

feature "User can vote for another user's question", %q{
  In order to vote for liked question
  As an authenticated user
  I'd like to be able to vote for another user's question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    describe "tries for another user's question" do
      background do
        sign_in(another_user)
        visit question_path(question)
      end

      scenario 'to vote up' do
        within '.question' do
          click_on "+"

          within "#question-votes-number-#{question.id}" do
            expect(page).to have_content '1'
          end
        end
      end

      scenario 'to vote up three times' do
        within '.question' do
          3.times { click_on "+" }

          within "#question-votes-number-#{question.id}" do
            expect(page).to have_content '1'
          end
        end
      end

      scenario 'to vote down' do
        within '.question' do
          click_on "-"

          within "#question-votes-number-#{question.id}" do
            expect(page).to have_content '-1'
          end
        end
      end

      scenario 'to vote down two times' do
        within '.question' do
          2.times { click_on "-" }

          within "#question-votes-number-#{question.id}" do
            expect(page).to have_content '-1'
          end
        end
      end

      scenario 'to vote up-down, down-up' do
        within '.question' do
          click_on "+"

          within "#question-votes-number-#{question.id}" do
            expect(page).to have_content '1'
          end

          click_on "-"

          within "#question-votes-number-#{question.id}" do
            expect(page).to have_content '0'
          end
        end

        within '.question' do
          click_on "-"

          within "#question-votes-number-#{question.id}" do
            expect(page).to have_content '-1'
          end

          click_on "+"

          within "#question-votes-number-#{question.id}" do
            expect(page).to have_content '0'
          end
        end
      end
    end

    describe "tries for his own question" do
      scenario 'to vote up or down' do
        sign_in(user)
        visit question_path(question)

        within '.question' do
          expect(page).not_to have_link '+'
          expect(page).not_to have_link '-'

          within "#question-votes-number-#{question.id}" do
            expect(page).to have_content '0'
          end
        end
      end
    end
  end

  scenario "Unauthenticated user tries to vote up or down" do
    visit question_path(question)

    within '.question' do
      expect(page).not_to have_link '+'
      expect(page).not_to have_link '-'

      within "#question-votes-number-#{question.id}" do
        expect(page).to have_content '0'
      end
    end
  end
end
