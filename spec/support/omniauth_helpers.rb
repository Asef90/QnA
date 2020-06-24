module OmniauthHelpers
  def mock_github

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      provider: 'Github',
      uid: '123545',
      info: {
        email: 'mockuser@user.ru'
      }
    })
  end

  def mock_vkontakte
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
      provider: 'Vkontakte',
      uid: '123545',
      info: {
      }
    })
  end
end
