class AuthorizationsMailer < ApplicationMailer

  def confirm_authorization(email, token)
    @token = token
    
    mail to: email
  end
end
