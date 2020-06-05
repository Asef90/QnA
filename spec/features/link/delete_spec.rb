require 'rails_helper'

feature 'User can delete link', %q{
  In order to make changes
  As an author of resource
  I'd like to be able to delete links
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:question_link) { create(:link, :for_question, linkable: question) }
  given!(:answer_link) { create(:link, :for_answer, linkable: answer) }

  describe 'Authenticated user', js: true do
    describe 'tries to delete link' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'from his question' do

        within '.question' do
          expect(page).to have_link question_link.name, href: question_link.url

          page.accept_confirm do
            click_on 'Delete link'
          end
        end

        within '.question' do
          expect(page).not_to have_link question_link.name
        end
      end

      scenario 'from his answer' do
        within '.answers' do
          expect(page).to have_link answer_link.name, href: answer_link.url

          page.accept_confirm do
            click_on 'Delete link'
          end
        end

        within '.answers' do
          expect(page).not_to have_link answer_link.name
        end
      end
    end

    scenario "tries to delete link from another user's record" do
      sign_in(another_user)
      visit question_path(question)

      expect(page).not_to have_link 'Delete link'
    end
  end

  scenario 'Unauthenticated user tries to delete file from the record', js: true do
    visit question_path(question)

    expect(page).not_to have_link 'Delete link'
  end
end
