class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    handle_oauth("Github")
  end

  def vkontakte
    handle_oauth("Vkontakte")
  end

  private

  def handle_oauth(kind)
    auth = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      session.merge!(provider: auth.provider, uid: auth.uid.to_s)
      redirect_to authorizations_confirmation_path
    end
  end
end
