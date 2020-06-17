require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }
  background { visit new_user_session_path }

  describe 'Sign in with email/password' do
    scenario 'Registered user tries to sign in' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'Unregistered user tries to sign in' do
      fill_in 'Email', with: 'wrong@test.com'
      fill_in 'Password', with: '123456'
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end
  end

  describe 'Sign in with Oauth services' do
    describe "returning user's email" do
      it 'sign in' do
        expect(page).to have_content("Sign in with GitHub")
        mock_github
        click_on "Sign in with GitHub"

        expect(page).to have_link "Sign out"
        expect(page).to have_content 'Successfully authenticated from Github account.'
      end
    end

    describe "not returning user's email" do
      it "sign in after email confirmation" do
        expect(page).to have_content("Sign in with Vkontakte")
        mock_vkontakte
        click_on "Sign in with Vkontakte"

        fill_in 'Email', with: user.email
        click_on 'Send email'

        expect(page).to have_content('Confirmation email has been sent to your email.')

        open_email(user.email)
        current_email.click_link 'Confirm'
     #    По клику Confirm выдаёт следующую ошибку
     #    Failure/Error: if @authorization.token == params[:token].to_i
     #    NoMethodError:
     #    undefined method `token' for nil:NilClass

        expect(page).to have_content('Thanks for confirming your mail.')

        visit new_user_session_path
        click_on "Sign in with Vkontakte"

        expect(page).to have_link "Sign out"
        expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
      end
    end
  end
end
