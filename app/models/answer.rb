class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  default_scope { order(best_mark: :desc) }

  def set_best_mark
    transaction do
      Answer.where(question_id: question_id).update_all(best_mark: false)
      update(best_mark: true)
    end
  end

  def best?
    best_mark
  end
end
