require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:example_url) { 'https://yandex.ru' }

  scenario 'User adds link when create answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'Test answer'

    fill_in 'Link name', with:'yandex'
    fill_in 'Url', with: example_url

    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link 'yandex', href: example_url
    end
  end
end
