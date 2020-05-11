require 'rails_helper'

feature 'User can watch question and answers to it', %q{
  In order to view problem and solutions
  As an user
  I'd like to be able to view question and answers to it
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 3, question: question, author: user) }

  scenario 'Authenticated user can watch question and answers to it' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    expect(page).to have_content(answers.first.body)
    expect(page).to have_content(answers.second.body)
    expect(page).to have_content(answers.third.body)
  end

  scenario 'Unauthenticated user can watch question and answers to it' do
    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    expect(page).to have_content(answers.first.body)
    expect(page).to have_content(answers.second.body)
    expect(page).to have_content(answers.third.body)
  end
end
