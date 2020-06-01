class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many :links, as: :linkable, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  default_scope { order(best_mark: :desc) }

  def set_best_mark
    unless best?
      update_best_answer
      give_reward_to_author
    end
  end

  def best?
    best_mark
  end

  private
  def update_best_answer
    transaction do
      reset_all_answers_best_mark
      update!(best_mark: true)
    end
  end

  def reset_all_answers_best_mark
    Answer.where(question_id: question_id).update_all(best_mark: false)
  end

  def give_reward_to_author
    author.give_reward(question.reward) if question.with_reward?
  end
end
