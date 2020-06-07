require 'rails_helper'

feature "User can vote for another user's answer", %q{
  In order to vote for liked answer
  As an authenticated user
  I'd like to be able to vote for another user's answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user', js: true do
    describe "tries for another user's answer" do
      background do
        sign_in(another_user)
        visit question_path(question)
      end

      scenario 'to vote up' do
        within '.answers' do
          click_on "+"

          within "#answer-votes-number-#{answer.id}" do
            expect(page).to have_content '1'
          end
        end
      end

      scenario 'to vote up three times' do
        within '.answers' do
          3.times { click_on "+" }

          within "#answer-votes-number-#{answer.id}" do
            expect(page).to have_content '1'
          end
        end
      end

      scenario 'to vote down' do
        within '.answers' do
          click_on "-"

          within "#answer-votes-number-#{answer.id}" do
            expect(page).to have_content '-1'
          end
        end
      end

      scenario 'to vote down two times' do
        within '.answers' do
          2.times { click_on "-" }

          within "#answer-votes-number-#{answer.id}" do
            expect(page).to have_content '-1'
          end
        end
      end

      scenario 'to vote up-down, down-up' do
        within '.answers' do
          click_on "+"

          within "#answer-votes-number-#{answer.id}" do
            expect(page).to have_content '1'
          end

          click_on "-"

          within "#answer-votes-number-#{answer.id}" do
            expect(page).to have_content '0'
          end
        end

        within '.answers' do
          click_on "-"

          within "#answer-votes-number-#{answer.id}" do
            expect(page).to have_content '-1'
          end

          click_on "+"

          within "#answer-votes-number-#{answer.id}" do
            expect(page).to have_content '0'
          end
        end
      end
    end

    describe "tries for his own answer" do
      scenario 'to vote up or down' do
        sign_in(user)
        visit question_path(question)

        within '.answers' do
          expect(page).not_to have_link '+'
          expect(page).not_to have_link '-'

          within "#answer-votes-number-#{answer.id}" do
            expect(page).to have_content '0'
          end
        end
      end
    end
  end

  scenario "Unauthenticated user tries to vote up or down" do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link '+'
      expect(page).not_to have_link '-'

      within "#answer-votes-number-#{answer.id}" do
        expect(page).to have_content '0'
      end
    end
  end
end
