class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s, confirmed: true)
    return authorization.user if authorization

    authorization = Authorization.create(provider: auth.provider, uid: auth.uid.to_s)
    if email = auth.info[:email]
      user = User.find_or_create(email)
      authorization.update(user_id: user.id, confirmed: true)
    end
    user
  end
end
