require 'rails_helper'

feature 'User can view the list of his rewards', %q{
  In order to making self feel better
  As an rewards owner
  I'd like to be able to view list if my rewards
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:reward) { create(:reward, question: question, user: another_user) }

  background { reward.image.attach(create_file_blob) }

  scenario 'Reward owner tries to view his rewards' do
    sign_in(another_user)

    click_on 'My rewards'

    expect(page).to have_content reward.question.title
    expect(page).to have_content reward.title
    expect(page.find('img')['src']).to have_content reward.image.filename.to_s
  end

  scenario 'Not owner of the reward tries to view his rewards' do
    sign_in(user)

    click_on 'My rewards'

    expect(page).not_to have_content reward.question.title
    expect(page).not_to have_content reward.title
    expect(page).to have_no_css 'img'
  end

  scenario 'Unauthenticated user can not edit answer' do
    expect(page).to_not have_link 'My rewards'
  end

end
