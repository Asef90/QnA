class AuthorizationsMailer < ApplicationMailer

  def confirm_authorization(email, authorization)
    @token = authorization.token
    @id = authorization.id
    @email = email

    mail to: email
  end
end
