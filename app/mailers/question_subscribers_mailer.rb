class QuestionSubscribersMailer < ApplicationMailer
  def notification(subscriber, answer)
    @answer = answer
    
    mail to: subscriber.email
  end
end
