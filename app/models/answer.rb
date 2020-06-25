class Answer < ApplicationRecord
  BUCKET_PATH = 'https://qna-files.s3-eu-west-1.amazonaws.com/'

  include Attachable
  include Authorable
  include Commentable
  include Linkable
  include Votable

  belongs_to :question

  validates :body, presence: true

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

  def publish
    files_data = []
    files.each {|file| files_data.push(name: file.filename.to_s, url: "#{BUCKET_PATH}#{file.key}")}

    AnswersChannel.broadcast_to question, answer: self,
                                          files: files_data,
                                          links: links,
                                          question_author_id: question.author_id
  end

end
