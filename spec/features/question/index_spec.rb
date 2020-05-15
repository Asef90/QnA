require 'rails_helper'

feature 'User can watch all questions', %q{
  In order to solve my problem
  As an user
  I'd like to be able to watch all questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, author: user) }

  scenario 'Authenticated user tries to view the list of all questions' do
    sign_in(user)
    visit questions_path

    expect(page).to have_content(questions.first.title)
    expect(page).to have_content(questions.second.title)
    expect(page).to have_content(questions.third.title)
  end

  scenario 'Unauthenticated user tries to view the list of all questions' do
    visit questions_path

    expect(page).to have_content(questions.first.title)
    expect(page).to have_content(questions.second.title)
    expect(page).to have_content(questions.third.title)
  end
end
