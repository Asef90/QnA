# Preview all emails at http://localhost:3000/rails/mailers/question_subscribers
class QuestionSubscribersPreview < ActionMailer::Preview
  def notification
    QuestionSubscribersMailer.notification(User.first, Answer.first)
  end
end
