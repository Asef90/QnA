class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_for question
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def question
    Question.find(params[:question_id])
  end
end
