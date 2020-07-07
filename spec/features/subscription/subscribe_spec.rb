require 'rails_helper'

feature 'User can subscribe', %q{
  In order to get new answers notification
  As an authenticated user
  I'd like to be able to subscribe question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:subscription) { create(:subscription, subscriptable: question, user: user) }

  scenario 'User subscribes to question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      expect(page).to have_link 'Unsubscribe'
    end

    click_on 'Unsubscribe'

    within '.question' do
      expect(page).to have_link 'Subscribe'
    end
  end
end
