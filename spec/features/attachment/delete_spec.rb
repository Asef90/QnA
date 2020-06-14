require 'rails_helper'

feature 'User can delete file', %q{
  In order to make changes
  As an author of question or answer
  I'd like to be able to delete file
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answer) { create(:answer, question: question, author: user) }

  background do
    question.files.attach(create_file_blob)
    answer.files.attach(create_file_blob)
  end

  describe 'Authenticated user', js: true do
    describe 'tries to delete file' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'from his question' do
        within '.question' do
          expect(page).to have_link 'image.jpg'

          page.accept_confirm do
            click_on 'Delete file'
          end
        end

        sleep(10)

        within '.question' do
          expect(page).not_to have_link 'image.jpg'
        end
      end

      scenario 'from his answer' do
        within '.answers' do
          expect(page).to have_link 'image.jpg'

          page.accept_confirm do
            click_on 'Delete file'
          end
        end

        sleep(10)

        within '.answers' do
          expect(page).not_to have_link 'image.jpg'
        end
      end
    end

    scenario "tries to delete file from another user's record" do
      sign_in(another_user)
      visit question_path(question)

      expect(page).not_to have_link 'Delete file'
    end
  end

  scenario 'Unauthenticated user tries to delete file from the record', js: true do
    visit question_path(question)

    expect(page).not_to have_link 'Delete file'
  end
end
