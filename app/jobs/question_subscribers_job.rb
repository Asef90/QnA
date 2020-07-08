class QuestionSubscribersJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.each do |subscriber|
      QuestionSubscribersMailer.notification(subscriber, answer).deliver_later unless subscriber.author?(answer)
    end
  end
end
