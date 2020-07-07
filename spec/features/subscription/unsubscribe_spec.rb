require 'rails_helper'

feature 'User can unsubscribe', %q{
  In order to stop receiving of new answers notification
  As an authenticated user
  I'd like to be able to unsubscribe question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'User unsubscribes from question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      expect(page).to have_link 'Subscribe'
    end

    click_on 'Subscribe'

    within '.question' do
      expect(page).to have_link 'Unsubscribe'
    end
  end
end
