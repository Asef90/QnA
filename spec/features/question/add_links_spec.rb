require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:example_url) { 'https://yandex.ru' }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    2.times { click_on 'add link' }

    all('.nested-fields').each do |field|
      within(field) do
        fill_in 'Link name', with:'yandex'
        fill_in 'Url', with: example_url
      end
    end

    click_on 'Ask'

    within '.question' do
      expect(page).to have_link 'yandex', href: example_url, count: 3
    end
  end
end
