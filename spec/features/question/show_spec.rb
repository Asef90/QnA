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
    answers.each { |answer| expect(page).to have_content(answer.body) }
  end

  scenario 'Unauthenticated user can watch question and answers to it' do
    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    answers.each { |answer| expect(page).to have_content(answer.body) }
  end

  describe 'With gist link' do
    given!(:gist_link) { create(:link, linkable: question, url: 'https://gist.github.com/Asef90/a22d4e70429275c852cfef89cbb0c8f5') }

    scenario 'User can view gist content' do
      visit question_path(question)

      expect(page).to have_content 'test-guru-question.txt'
      expect(page).to have_content 'The capital of Italy?'
    end
  end
end
