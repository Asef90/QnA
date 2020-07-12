require 'sphinx_helper'

feature 'User can search for resource', "
  In order to find needed resources
  As a User
  I'd like to be able to search for the resources
" do

  let!(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let!(:comment) { create(:comment, commentable: answer, body: 'unique comment body') }

  let!(:another_user) { create(:user) }
  let(:another_question) { create(:question) }
  let(:another_answer) { create(:answer, question: another_question) }
  let!(:another_comment) { create(:comment, commentable: another_answer) }


  scenario 'User searches for the answer', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
       fill_in 'Search for:', with: answer.body
       select 'Answer', from: 'area'

       click_on 'Search'

       expect(page).to have_link answer.body, href: question_path(question)
       expect(page).not_to have_content another_answer.body
       expect(page).not_to have_content question.title
       expect(page).not_to have_content another_question.title
       expect(page).not_to have_content comment.body
       expect(page).not_to have_content another_comment.body
       expect(page).not_to have_content user.email
       expect(page).not_to have_content another_user.email
    end
  end

  scenario 'User searches for the question', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
       fill_in 'Search for:', with: question.title
       select 'Question', from: 'area'

       click_on 'Search'

       expect(page).to have_link question.title, href: question_path(question)
       expect(page).not_to have_content answer.body
       expect(page).not_to have_content another_answer.body
       expect(page).not_to have_content another_question.title
       expect(page).not_to have_content comment.body
       expect(page).not_to have_content another_comment.body
       expect(page).not_to have_content user.email
       expect(page).not_to have_content another_user.email
    end
  end

  scenario 'User searches for the comment', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
       fill_in 'Search for:', with: comment.body
       select 'Comment', from: 'area'

       click_on 'Search'

       expect(page).to have_link comment.body, href: question_path(question)
       expect(page).not_to have_content answer.body
       expect(page).not_to have_content another_answer.body
       expect(page).not_to have_content question.title
       expect(page).not_to have_content another_question.title
       expect(page).not_to have_content another_comment.body
       expect(page).not_to have_content user.email
       expect(page).not_to have_content another_user.email
    end
  end

  scenario 'User searches for the user', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
       fill_in 'Search for:', with: user.email
       select 'User', from: 'area'

       click_on 'Search'

       expect(page).to have_content user.email
       expect(page).not_to have_content answer.body
       expect(page).not_to have_content another_answer.body
       expect(page).not_to have_content question.title
       expect(page).not_to have_content another_question.title
       expect(page).not_to have_content comment.body
       expect(page).not_to have_content another_comment.body
       expect(page).not_to have_content another_user.email
    end
  end

  describe 'Global search' do
    background do
      question.update(body: 'unique')
      another_answer.update(body: 'unique')
      another_user.update(email: 'unique@user')
    end
    scenario 'User searches for the all entities', sphinx: true, js: true do
      visit root_path

      ThinkingSphinx::Test.run do
         fill_in 'Search for:', with: 'unique'
         select 'All', from: 'area'

         click_on 'Search'

         expect(page).to have_link question.title, href: question_path(question)
         expect(page).to have_link comment.body, href: question_path(question)
         expect(page).to have_link another_answer.body, href: question_path(another_question)
         expect(page).to have_content another_user.email
         expect(page).not_to have_content answer.body
         expect(page).not_to have_content another_question.title
         expect(page).not_to have_content another_comment.body
         expect(page).not_to have_content user.email
      end
    end
  end
end
