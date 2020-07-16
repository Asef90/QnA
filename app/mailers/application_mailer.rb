class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials[Rails.env.to_sym][:mailer][:user_name]
  layout 'mailer'
end
