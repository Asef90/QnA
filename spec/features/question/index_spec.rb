require 'rails_helper'

feature 'User can view all questions', %q{
  In order to solve my problem
  As an user
  I'd like to be able to view all questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }

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
