class Answer < ApplicationRecord

  include Attachable
  include Authorable
  include Commentable
  include Linkable
  include Votable

  belongs_to :question, touch: true

  validates :body, presence: true

  after_create :notify_subscribers
  after_create_commit :publish

  default_scope { order(best_mark: :desc) }

  def set_best_mark
    unless best?
      transaction do
        Answer.where(question_id: question_id).update_all(best_mark: false)
        update!(best_mark: true)
        author.give_reward(question.reward) if question.with_reward?
      end
    end
  end

  def best?
    best_mark
  end

  private

  def notify_subscribers
    QuestionSubscribersJob.perform_later(self)
  end

  def publish
    files_data = []
    files.each {|file| files_data.push(name: file.filename.to_s, url: Rails.application.routes.url_helpers.rails_blob_url(file))}

    AnswersChannel.broadcast_to question, answer: self,
                                          files: files_data,
                                          links: links,
                                          question_author_id: question.author_id
  end

end
