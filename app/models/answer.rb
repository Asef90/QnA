class Answer < ApplicationRecord
  include Attachable
  include Authorable
  include Linkable
  include Votable

  belongs_to :question

  validates :body, presence: true

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

end
